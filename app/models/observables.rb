require 'hashie'
module Cikl
  module Models
    class Observables < Hashie::Dash
      property :ipv4, default: lambda { [] }
      property :fqdn, default: lambda { [] }
      property :dns_answer, default: lambda { [] }
    end
  end
end

