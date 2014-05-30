require 'grape'
require 'grape-entity'
require 'api/entities/observables'
module Cikl
  module API
    module Entities
      class Event < Grape::Entity
        expose :reporttime
        expose :detecttime
        expose :source
        expose :observables, using: Cikl::API::Entities::Observables
      end
    end
  end
end
