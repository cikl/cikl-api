require 'jbuilder'
require 'models/response'
require 'models/event'
require 'models/observables'
require 'models/observable/ipv4'
require 'models/observable/fqdn'
require 'models/observable/dns_answer'
require 'api/entities/response'

module Cikl
  module API
    module Helpers
      module Query
        def es_timestamp_query(z)
          z.range do |z|
            z.set!("@timestamp") do |z|
              z.gte params.detecttime_min.iso8601
              z.lte params.detecttime_max.iso8601 if params.detecttime_max?
            end
          end
        end

        def es_nested_any(z, path, query, fields = [])
          z.nested do 
            z.path path
            z.query do
              z.multi_match do |z|
                z.query query
                z.fields fields 
              end # multi_match
            end
          end
        end

        def run_standard_query
          query = Jbuilder.encode do |z|
            z.query do
              z.bool do

                z.must do
                  # Allow for caller to customize query.
                  z.child! do
                    z.bool do
                      yield(z)
                    end
                  end

                  z.child! do
                    es_timestamp_query(z)
                  end
                end # must
              end
            end
          end

          run_query_and_return(query)
        end

        def run_query_and_return(query)
          es_response = run_query(query)

          present hits_to_response(es_response['hits']['hits']), with: Cikl::API::Entities::Response
        end
        def run_query(query)
          elasticsearch_client.search({
            index: 'cikl-*',
            size: params[:size],
            from: params[:from],
            body: query
          })
        end

        
        def hits_to_response(hits)
          response = Cikl::Models::Response.new
          events = response.events
          hits_to_events(hits) do |event|
            events << event
          end
          response
        end

        def hits_to_events(hits)
          return enum_for(:hits_to_events, hits) unless block_given?
          hits.each do |hit|
            case hit["_type"]
            when 'event'
              src = hit["_source"]
              event = Cikl::Models::Event.new({ 
                detecttime: src["@timestamp"],
                reporttime: src["reporttime"],
                source: src["source"]
              })
              src["observables"].each_pair do |key, val|
                dest = nil
                klass = nil
                case key
                when "ipv4"
                  dest = event.observables.ipv4
                  klass = Cikl::Models::Observable::Ipv4
                when "fqdn"
                  dest = event.observables.fqdn
                  klass = Cikl::Models::Observable::Fqdn
                when "dns_answer"
                  dest = event.observables.dns_answer
                  klass = Cikl::Models::Observable::DnsAnswer
                else 
                  next
                end
                val.each do |obj|
                  dest << klass.new(obj)
                end
              end
              yield event
            else 
              nil
            end
          end
        end

      end
    end
  end
end



