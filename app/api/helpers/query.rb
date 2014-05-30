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
        def run_standard_query
          query = Jbuilder.encode do |json|
            json.query do |json|
              json.bool do |json|
                # Allow for caller to customize query.
                yield(json)

                json.must do |json|
                  json.range do |json|
                    json.set!("@timestamp") do |json|
                      json.gte params.detecttime_min.iso8601
                      json.lte params.detecttime_max.iso8601 if params.detecttime_max?
                    end
                  end
                end # must
              end
            end
          end
          es_response = elasticsearch_client.search({
            index: 'cikl-*',
            size: params[:size],
            from: params[:from],
            body: query
          })

          present hits_to_response(es_response['hits']['hits']), with: Cikl::API::Entities::Response
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
              src["address"].each_pair do |key, val|
                case key
                when "ipv4"
                  event.observables.ipv4 << Cikl::Models::Observable::Ipv4.new(
                    :ipv4 => val
                  )
                when "fqdn"
                  event.observables.fqdn << Cikl::Models::Observable::Fqdn.new(
                    :fqdn => val
                  )
                end
              end
              yield event
            when 'dns_answer'
              src = hit["_source"]
              event = Cikl::Models::Event.new({
                detecttime: src["@timestamp"],
                reporttime: src["@timestamp"],
                source: "resolver"
              })
              dns_answer = Cikl::Models::Observable::DnsAnswer.new({ 
                resolver: src["worker"],
                name: src["name"],
                section: src["section"],
                rr_class: src["rr_class"],
                rr_type: src["rr_type"],
                ipv4: src["ipv4"],
                ipv6: src["ipv6"],
                fqdn: src["fqdn"]
              })
              event.observables.dns_answer << dns_answer
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



