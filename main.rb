# frozen_string_literal: true

require 'bundler/setup'
require 'discordrb'
require_relative './lib/koyuki'

token = ENV['KOYUKI_TOKEN']

koyuki = Koyuki.new(token)
result = koyuki.run
puts result
