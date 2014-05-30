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
      end
    end
  end
end

