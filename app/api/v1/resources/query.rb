require 'grape'
require 'api/helpers/query'
require 'date'

module Cikl
  module API
    module V1
      module Resources
        class Query < Grape::API
          params do
            optional :size, type: Integer, default: 50, in_range: 1..2000
            optional :from, type: Integer, default: 0
            optional :assessment, type: String
            optional :detecttime_min, type: DateTime, default: lambda { DateTime.now - 30 } # 30 days ago 
            optional :detecttime_max, type: DateTime
          end

          helpers Cikl::API::Helpers::Query

          namespace :query do
            # ipv4 handling
            params do
              requires :ipv4, type: String, regexp: /^(\d{1,3}\.){3}(\d{1,3})$/
            end
            resource :ipv4 do
              post do
                run_standard_query do |json|
                  json.must do |json|
                    json.multi_match do |json|
                      json.query params[:ipv4]
                      json.fields [
                        'event.address.ipv4',
                        'dns_answer.ipv4'
                      ]
                    end # multi_match
                  end
                end
              end
            end

            # fqdn handling
            params do
              requires :fqdn, type: String
            end
            resource :fqdn do
              post do
                run_standard_query do |json|
                  json.must do |json|
                    json.multi_match do |json|
                      json.query params[:fqdn]
                      json.fields [
                        'event.address.fqdn',
                        'dns_answer.name',
                        'dns_answer.fqdn'
                      ]
                    end # multi_match
                  end
                end # run_standard_query
              end # post
            end

          end

          ###
        end
      end

    end
  end
end
