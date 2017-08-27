# frozen_string_literal: true

require 'hbtrack/habit_tracker'
require 'hbtrack/version'
require 'hbtrack/cli'
require 'hbtrack/util'
require 'hbtrack/config'
require 'hbtrack/habit'
require 'hbtrack/stat_formatter'
require 'hbtrack/habit_printer'
require 'hbtrack/error_handler'

module Hbtrack
  class << self
    def run
      if ARGV.empty?
        HabitTracker.help
      else
        HabitTracker.new.parse_arguments(ARGV)
      end
    end
  end
end
