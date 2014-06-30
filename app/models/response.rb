require 'virtus'
require 'models/event'
require 'models/query_params'

module Cikl
  module Models
    class Response
      include Virtus.model
      attribute :events, Array[Cikl::Models::Event], default: lambda { |r, a| [] }
      attribute :total_events, Integer
      attribute :timing_elasticsearch_total
      attribute :timing_elasticsearch_internal_query
      attribute :timing_backend_total
      attribute :query, Cikl::Models::QueryParams
    end
  end
end

