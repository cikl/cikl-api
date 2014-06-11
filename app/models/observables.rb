require 'hashie'
require 'models/observable/dns_answer'
require 'models/observable/ipv4'
require 'models/observable/fqdn'

module Cikl
  module Models
    class Observables < Hashie::Dash
      property :ipv4, default: lambda { [] }
      property :fqdn, default: lambda { [] }
      property :dns_answer, default: lambda { [] }
    end
  end
end

