require 'hashie'

module Cikl
  module Models
    class Response < Hashie::Dash
      property :events, default: lambda { [] }
    end
  end
end

