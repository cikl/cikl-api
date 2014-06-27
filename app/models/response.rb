require 'virtus'
require 'models/event'

module Cikl
  module Models
    class Response
      include Virtus.model
      attribute :events, Array[Cikl::Models::Event], default: lambda { |r, a| [] }
      attribute :page, Integer, default: 1
      attribute :per_page, Integer, default: 50
      attribute :total, Integer
      attribute :timing_elasticsearch_total
      attribute :timing_elasticsearch_internal_query
      attribute :timing_backend_total
    end
  end
end

