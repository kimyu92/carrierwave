# encoding: utf-8

require 'rails'
require 'carrierwave/orm/activerecord'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Migration.verbose = false
