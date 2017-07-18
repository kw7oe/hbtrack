# frozen_string_literal: true

require 'hbtrack/habit_tracker'

module Hbtrack
  class << self
    def run *args
      if ARGV.empty?
        HabitTracker.help
      else
        HabitTracker.new.parse_arguments(*args)
      end
    end
  end
end
