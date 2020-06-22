# frozen_string_literal: true

class Greeter
  attr_reader :template

  def initialize(template)
    @template = template
  end

  def greet(user: '', server: '')
    @template.gsub('{user}', user).gsub('{server}', server)
  end

  def change_template(new_template)
    Greeter.new(new_template)
  end

  def ==(other)
    @template == other.template
  end
end
