# This file (and the related Rails app) constructed with the help of
# https://stackoverflow.com/a/33929321

ENV["RAILS_ENV"] = 'test'
require 'rails/all'
require 'support/test_app/config/environment'
ActiveRecord::Migration.maintain_test_schema!
ActiveRecord::Schema.verbose = false
require 'spec_helper'
