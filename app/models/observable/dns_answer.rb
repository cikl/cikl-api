require 'hashie'

module Cikl
  module Models
    module Observable

      class DnsAnswer < Hashie::Dash
        property :resolver
        property :name
        property :rr_class
        property :rr_type
        property :section
        property :ipv4
        property :ipv6
        property :fqdn
      end

    end
  end
end
