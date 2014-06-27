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
          orig_start = Time.now
          es_response = run_query(query)
          timing_elasticsearch_total = Time.now - orig_start

          start = Time.now
          response = build_response(es_response)
          response.timing_backend_total = ((Time.now - start) * 1000).to_i
          response.timing_elasticsearch_internal_query = es_response["took"].to_i
          response.timing_elasticsearch_total = (timing_elasticsearch_total * 1000).to_i

          start = Time.now
          serialized = Cikl::API::Entities::Response.represent(response, :serializable => true)
          serialized_total = Time.now - start
          total = Time.now - orig_start

          serialized[:timing][:serialization] = { :total => (serialized_total * 1000).to_i }
          serialized[:timing][:total] = (total * 1000).to_i
          serialized
        end
        def run_query(query)
          elasticsearch_client.search({
            index: 'cikl-*',
            size: params[:size],
            from: params[:from],
            fields: [],
            body: query
          })
        end

        
        def build_response(es_response)
          response = Cikl::Models::Response.new
          events = response.events
          hits_to_events(es_response["hits"]["hits"]) do |event|
            events << event
          end

          response
        end

        def hits_to_events_es(hits)
          return enum_for(:hits_to_events_es, hits) unless block_given?

          hits.each do |hit|
            yield Cikl::Models::Event.from_hash(hit["_source"])
          end
        end
        def hits_to_events(hits)
          return enum_for(:hits_to_events, hits) unless block_given?
          ids = hits.map { |hit| hit["_id"] }

          mongo_each_event(ids) do |obj|
            yield Cikl::Models::Event.from_hash(obj)
          end
        end

      end
    end
  end
end



