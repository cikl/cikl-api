require 'api/root'
require 'middleware/elasticsearch'

module Cikl
  class App
    def initialize()
    end

    def self.instance
      @instance ||= Rack::Builder.new do
        use Rack::Cors do
          allow do
            origins '*'
            resource '*', headers: :any, methods: :get
          end
        end

        use Cikl::Middleware::Elasticsearch, {}

        run Cikl::App.new
      end.to_app
    end

    def call(env)
      Cikl::API::Root.call(env)
    end
  end
end
