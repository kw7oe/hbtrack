# frozen_string_literal: true

require_relative 'lib/habit_tracker'

# CLI for the application
module Hb
  def self.run(args)
    habit_tracker = HabitTracker.new("test_data")
    habit_tracker.parse_arguments(args)
  end
end

Hb.run(ARGV)
