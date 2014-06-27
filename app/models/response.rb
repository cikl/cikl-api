require 'virtus'
require 'models/event'

module Cikl
  module Models
    class Response
      include Virtus.model
      attribute :events, Array[Cikl::Models::Event], default: lambda { |r, a| [] }
      attribute :timing_elasticsearch_total
      attribute :timing_elasticsearch_internal_query
      attribute :timing_backend_total
    end
  end
end

