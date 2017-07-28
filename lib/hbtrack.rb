# frozen_string_literal: true

require 'hbtrack/habit_tracker'
require 'hbtrack/version'
require 'hbtrack/cli'
require 'hbtrack/util'
require 'hbtrack/config'
require 'hbtrack/habit'
require 'hbtrack/stat_formatter'

module Hbtrack
  class << self
    def run(*args)
      if ARGV.empty?
        HabitTracker.help
      else
        HabitTracker.new.parse_arguments(*args)
      end
    end
  end
end
