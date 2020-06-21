# frozen_string_literal: true

require_relative '../lib/ping_pong'

class PingPongExtension
  def initialize(bot)
    @bot = bot
    @ping_pong = PingPong.new
  end

  def extend
    @bot.message do |event|
      answer = @ping_pong.ping(event.message.content)
      event.send_message(answer) unless answer.nil?
    end

    @bot
  end
end
