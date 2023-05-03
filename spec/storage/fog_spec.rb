# encoding: utf-8

require 'spec_helper'

FOG_CREDENTIALS.each do |credential|
  fog_tests(credential)
end
