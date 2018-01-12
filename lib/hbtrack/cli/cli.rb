# frozen_string_literal: true

require 'hbtrack/habit_tracker'
require 'hbtrack/command/list_command'
require 'hbtrack/command/update_command'
require 'hbtrack/command/remove_command'
require 'hbtrack/command/add_command'

module Hbtrack
  module CLI
    class << self
      def run(args)
        hbt = HabitTracker.new
        command = case args.shift
                  when 'list'
                    ListCommand.new(hbt, args)
                  when 'done'
                    UpdateCommand.new(hbt, args, true)
                  when 'undone'
                    UpdateCommand.new(hbt, args, false)
                  when 'remove'
                    RemoveCommand.new(hbt, args)
                  when 'add'
                    AddCommand.new(hbt, args)
                  else
                    help
                  end
        puts command.execute
      end

      def help
        puts 'Usage: hbtrack <command> [<habit_name>] [options]'
        puts
        puts 'Commands:'
        puts '     add: Add habit(s)'
        puts '     remove: Remove habit(s)'
        puts '     list: List habit(s)'
        puts '     done: Mark habit(s) as done'
        puts '     undone: Mark habit(s) as undone'
        puts
        puts 'Options:'
        puts "     -h, --help\t\tShow help messages of the command"
        exit
      end
    end
  end
end