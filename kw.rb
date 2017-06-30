# frozen_string_literal: true

require_relative 'lib/habit_tracker'
require_relative 'lib/parser'

# CLI for the application
module Kw
  def self.run(file)
    parser = Parser.new(file)
    HabitTracker.new(parser.habits)
  end
end

Kw.run(ARGV[0])
