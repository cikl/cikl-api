require 'virtus'
require 'date'

module Cikl
  module Models
    class QueryParams
      include Virtus.model
      attribute :start, Integer
      attribute :per_page, Integer
      attribute :assessment, String
      attribute :timing, Integer
      attribute :detecttime_min, DateTime
      attribute :detecttime_max, DateTime
    end
  end
end


