require 'grape'
require 'grape-entity'
require 'api/entities/observable/dns_answer'
require 'api/entities/observable/ipv4'
require 'api/entities/observable/fqdn'

module Cikl
  module API
    module Entities
      class QueryParams < Grape::Entity
        format_with(:iso_timestamp) { |dt| dt.iso8601 if dt.respond_to?(:iso8601) }
        expose :start,
          documentation: {
            type: Integer,
            default: 1,
            desc: "The index of the current set of events into the total set of events, where the index of the first event is 1"
          }

        expose :per_page, 
          documentation: {
            type: Integer,
            default: 50, 
            in_range: 1..2000,
            desc: "Number of events per page. Expects: Integer between 1 and 2000. Default: 50."
          }

        expose :assessment,
          documentation: {
            type: String
          }

        with_options(format_with: :iso_timestamp) do
          expose :detecttime_min,
            documentation: {
              type: DateTime,
              default: lambda { DateTime.now - 30 } # 30 days ago 
            }

          expose :detecttime_max,
            documentation: {
              type: DateTime
            }
        end
      end

    end
  end
end


