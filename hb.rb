#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/habit_tracker'

if ARGV.empty?
  HabitTracker.help
else
  HabitTracker.new.parse_arguments(ARGV)
end
