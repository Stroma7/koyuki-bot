# frozen_string_literal: true

require 'bundler/setup'
require 'rspec'
require_relative '../lib/ping_pong'

RSpec.describe PingPong do
  subject { PingPong.new }

  describe 'ping' do
    it 'return pong' do
      expect(subject.ping('ping')).to eq 'pong'
    end
  end
end
