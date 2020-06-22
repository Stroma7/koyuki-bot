# frozen_string_literal: true

class RoleManager
  attr_reader :emoji_role_map

  def initialize(template)
    @template = template
    @emoji_role_map = make_emoji_role_map
  end

  def embed
    description = parse_template.map do |emoji, role|
      "#{emoji} : #{role[0]}"
    end.join("\n") + "\n"

    Discordrb::Webhooks::Embed.new(
      title: '役割付与',
      description: "このメッセージにリアクションをすると, 対応するロールが付与されます.\n\n#{description}"
    )
  end

  def emoji_id(emoji)
    emoji.gsub(/<:[\w\W]+:|>/, '').to_i
  end

  private

  def make_emoji_role_map
    parse_template.map do |emoji, role|
      [emoji, role[1].to_i]
    end.to_h
  end

  def parse_template
    lines = @template.split("\n")

    return {} unless lines.all? { |line| line.match?(%r{[\w\W]+ : [\w\W]+/\d+}) }

    lines.map do |line|
      words = line.split
      words.delete(':')
      icon = words[0]
      role = words[1].split('/')

      [icon, role] # [emoji, [role_name, role_id]]
    end.to_h
  end
end
