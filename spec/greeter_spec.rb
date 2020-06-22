# frozen_string_literal: true

require 'bundler/setup'
require 'discordrb'
require_relative '../lib/greeter'

RSpec.describe Greeter do
  subject { Greeter.new(template) }
  let(:template) { 'Hi {user}. Welcome to {server}.' }

  describe '#greet' do
    it 'make welcome message based on the template' do
      result = subject.greet(user: 'Lain', server: 'Wired')
      expected = 'Hi Lain. Welcome to Wired.'

      expect(result).to eq expected
    end
  end

  describe 'change_template' do
    it 'change template' do
      result = subject.change_template('pi-pi-ga-')
      expected = Greeter.new('pi-pi-ga-')

      expect(result).to eq expected
    end
  end
end
