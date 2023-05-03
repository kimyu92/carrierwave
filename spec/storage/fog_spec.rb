
require 'spec_helper'
require 'fog/aws'
require 'fog/google'
require 'fog/local'
require 'fog/rackspace'
require 'carrierwave/storage/fog'

unless ENV['REMOTE'] == 'true'
  Fog.mock!
end

require_relative './fog_credentials' # after Fog.mock!
require_relative './fog_helper'

FOG_CREDENTIALS.each do |credential|
  fog_tests(credential)
end
