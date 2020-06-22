# frozen_string_literal: true

require_relative '../lib/role_manager'

class RoleManagerExtension
  def initialize(bot)
    @bot = bot
    @managers = {}
  end

  def extend
    @bot.message do |event|
      break unless event.message.content.split("\n")[0] == '!manage_role'

      template = event.message.content.split("\n")[1..].join("\n")
      role_manager = RoleManager.new(template)

      target_message = event.send_message('', false, role_manager.embed)

      @managers[target_message.id] = role_manager
      react(target_message)
    end

    @bot.reaction_add do |event|
      break unless @managers.include?(event.message.id)

      role = find_role(event)
      event.user.add_role(role)
    end

    @bot.reaction_remove do |event|
      break unless @managers.include?(event.message.id)

      role = find_role(event)
      event.user.remove_role(role)
    end

    @bot
  end

  private

  def react(message)
    manager = @managers[message.id]

    manager.emoji_role_map.keys.each do |emoji|
      emoji = message.channel.server.emoji[emoji] if emoji.is_a?(Integer)

      message.create_reaction(emoji)
    end
  end

  def find_role(event)
    manager = @managers[event.message.id]
    emoji = event.emoji.id || event.emoji.name

    role_id = manager.emoji_role_map[emoji]
    event.server.role(role_id)
  end
end
