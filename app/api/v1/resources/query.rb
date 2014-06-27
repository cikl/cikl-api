require 'grape'
require 'api/helpers/query'
require 'date'

module Cikl
  module API
    module V1
      module Resources
        class Query < Grape::API
          params do
            optional :per_page, type: Integer, 
              default: 50, in_range: 1..2000,
              desc: "Number of events per page. Expects: Integer between 1 and 2000. Default: 50."
            optional :page, type: Integer, default: 1,
              desc: "Page offset. Default: 1"

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
              IPV4_QUERY = [
                ["observables.ipv4", ["observables.ipv4.ipv4"]],
                ["observables.dns_answer", ["observables.dns_answer.ipv4"]],
              ]
              post do
                value = params[:ipv4]
                run_standard_query do |z|
                  z.should(IPV4_QUERY)  do |path, fields|
                    es_nested_any(z, path, value, fields)
                  end
                end
              end # post
            end # ipv4

            # fqdn handling
            params do
              requires :fqdn, type: String
            end
            resource :fqdn do
              FQDN_QUERY = [
                ["observables.fqdn", ["observables.fqdn.fqdn"]],
                ["observables.dns_answer", ["observables.dns_answer.name", "observables.dns_answer.fqdn"]],
              ]
              post do
                value = params[:fqdn]
                run_standard_query do |z|
                  z.should(FQDN_QUERY)  do |path, fields|
                    es_nested_any(z, path, value, fields)
                  end
                end
              end
            end

          end

          ###
        end
      end

    end
  end
end
