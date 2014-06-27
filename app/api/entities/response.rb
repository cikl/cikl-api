require 'grape'
require 'grape-entity'
require 'api/entities/event'
module Cikl
  module API
    module Entities
      class Response < Grape::Entity
        expose :count do |e,o| 
          e.events.count
        end
        expose :events, using: Cikl::API::Entities::Event
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

