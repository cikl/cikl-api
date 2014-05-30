# A sample Gemfile
source "https://rubygems.org"

gem 'grape'
gem 'grape-entity'
gem 'grape-swagger'
gem 'multi_json'
gem 'rack-cors'
gem 'elasticsearch'
gem 'connection_pool'
gem 'jbuilder'
gem 'hashie'
gem 'oj', :platforms => 'ruby'
gem 'jrjackson', :platforms => 'jruby'

group :production do
  gem 'unicorn'
end

group :development do
  platforms :jruby do
    gem 'warbler'
  end
end

group :test do
  gem 'rspec'
  gem 'rack-test'
  gem 'simplecov'
end
