# frozen_string_literal: true

require 'bundler/setup'
require 'discordrb'

class Koyuki
  def initialize(token)
    @token = token
    @bot = Discordrb::Bot.new token: token
  end

  def run
    return 'Set token to KOYUKI_TOKEN' if @token.empty?

    load_extensions
    @bot.run
  end

  private

  def load_extensions
    extension_path = Dir.glob('./extensions/*.rb')

    extension_path.each do |path|
      require path
      file_name = File.basename(path, '.rb')
      class_name = snake_to_camel(file_name) + 'Extension'

      extension = eval(class_name).new(@bot)
      @bot = extension.extend
    end
  end

  def snake_to_camel(str)
    words = str.split('_')
    words.map do |word|
      word[0].upcase + word[1..]
    end.join
  end
end
