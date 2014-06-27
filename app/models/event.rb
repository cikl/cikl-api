require 'virtus'
require 'models/observables'
module Cikl
  module Models
    class Event
      include Virtus.model
      attribute :reporttime, DateTime
      attribute :detecttime, DateTime
      attribute :source, String
      attribute :event_id, String
      attribute :observables, Cikl::Models::Observables, default: lambda { Cikl::Models::Observables.new }

      class << self
        def from_hash(obj)
          obj["detecttime"] = obj["@timestamp"] unless obj.has_key?("detecttime")
          new(obj)
        end
      end
    end
  end
end
