require 'grape'
require 'grape-entity'
require 'api/entities/query_params'
require 'api/entities/event'
module Cikl
  module API
    module Entities
      class Response < Grape::Entity
        expose :count, 
          documentation: { 
            type: 'integer', 
            desc: 'The number of events returned in this set' 
        } do |e,o| 
          e.events.count
        end

        expose :total_events, 
          documentation: { 
            type: 'integer', 
            desc: 'The total number of events that match the query'
          }

        expose :query,
           using: Cikl::API::Entities::QueryParams,
           documentation:
           {
             desc: 'The query parameters used to return this set of events'
           }

        expose :events, 
          using: Cikl::API::Entities::Event, 
          documentation: { 
            desc: 'The set of events matching the query' 
          }

        expose :timing do
          expose :backend do
            expose :timing_backend_total, as: :total
          end
          expose :elasticsearch do
            expose :timing_elasticsearch_total, as: :total
            expose :timing_elasticsearch_internal_query, as: :internal_query
          end
          expose :test do |model, options|
          end
        end
      end
    end
  end
end

