# frozen_string_literal: true

require 'bundler/setup'
require 'rspec'
require 'discordrb'
require_relative '../lib/role_manager'

RSpec.describe RoleManager do
  subject { RoleManager.new(template) }

  describe '#emoji_id' do
    let(:template) { '' }

    it 'take out emoji id from string emoji' do
      expect(subject.emoji_id('<:emoji7:111>')).to eq 111
    end
  end

  context 'normal template' do
    let(:template) do
      <<-MESSAGE
      <:emoji:100000000000000000> : Role1/100000000000000000
      👍 : Role2/100000000000000001
      MESSAGE
    end

    describe '#emoji_role_map' do
      it 'make the map based on the template' do
        expected = { '<:emoji:100000000000000000>' => 100000000000000000, '👍' => 100000000000000001 }
        result = subject.emoji_role_map

        expect(result).to eq expected
      end
    end

    describe '#embed' do
      it 'make embed' do
        map = <<~MAP
          <:emoji:100000000000000000> : Role1
          👍 : Role2
        MAP

        expected = Discordrb::Webhooks::Embed.new(
          title: '役割付与',
          description: "このメッセージにリアクションをすると, 対応するロールが付与されます.\n\n#{map}"
        )

        result = subject.embed
        expect(result.description).to eq expected.description
      end
    end
  end

  context 'wrong template' do
    let(:template) do
      <<-MESSAGE
      <:emoji:000000000000000000> : Role1
      WRONG WRONG
      MESSAGE
    end

    describe '#emoji_role_map' do
      it 'make empty hash' do
        expect(subject.emoji_role_map).to eq Hash.new
      end
    end
  end
end
