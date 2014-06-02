require 'grape'
require 'api/validators/in_range'
require 'api/helpers/elasticsearch'
require 'api/v1/resources/query'

module Cikl
  module API
    module V1
      class Root < Grape::API
        format :json

        helpers ::Cikl::API::Helpers::Elasticsearch
        mount ::Cikl::API::V1::Resources::Query
      end
    end
  end
end

