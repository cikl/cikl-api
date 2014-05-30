require 'grape'
require 'api/validators/in_range'
require 'api/helpers/elasticsearch'
require 'api/resources/query'

module Cikl
  module API
    class Root < Grape::API
      prefix 'api'
      helpers ::Cikl::API::Helpers::Elasticsearch
      mount ::Cikl::API::Resources::Query
      add_swagger_documentation
    end
  end
end

