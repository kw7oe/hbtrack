# frozen_string_literal: true

require 'hb/habit_tracker'

module Hb
  class << self
    def run *args
      if ARGV.empty?
        HabitTracker.help
      else
        puts "ARGV: #{ARGV}"
        HabitTracker.new.parse_arguments(*args)
      end
    end
  end
end
