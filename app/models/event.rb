require 'hashie'
require 'models/observables'
module Cikl
  module Models
    class Event < Hashie::Dash
      property :reporttime
      property :detecttime
      property :source
      property :observables, default: lambda { Cikl::Models::Observables.new }
    end
  end
end
