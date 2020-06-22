# frozen_string_literal: true

require_relative '../lib/greeter'

class GreeterExtension
  def initialize(bot)
    @bot = bot
    @greeter = Greeter.new('Welcome to {server}, {user}!')
  end

  def extend
    @bot.member_join do |event|
      message = @greeter.greet(user: event.user.mention, server: event.server.name)
      event.server.system_channel.send_message(message)
    end

    @bot.message do |event|
      break unless event.message.content.start_with?('!set_welcome_message')

      welcome_message = event.message.content.delete_prefix('!set_welcome_message')
      @greeter = @greeter.change_template(welcome_message)
    end

    @bot
  end
end
