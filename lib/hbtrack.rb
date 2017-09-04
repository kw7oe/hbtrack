# frozen_string_literal: true

require 'hbtrack/habit_tracker'
require 'hbtrack/habit'
require 'hbtrack/config'
require 'hbtrack/stat_formatter'
require 'hbtrack/habit_printer'
require 'hbtrack/command/list_command'
require 'hbtrack/command/update_command'
require 'hbtrack/error_handler'

module Hbtrack
  class << self
    def run(args)
      if ARGV.empty?
        HabitTracker.help
      else
        hbt = HabitTracker.new
        command = case args.shift
        when "list"
          ListCommand.new(hbt, args)
        when "done"
          UpdateCommand.new(hbt, args, true)
        when "undone"
          UpdateCommand.new(hbt, args, false)
        end
        puts command.execute                    
      end
    end
  end
end
