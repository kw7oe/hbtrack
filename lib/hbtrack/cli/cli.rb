# frozen_string_literal: true

require 'hbtrack/command/list_command'
require 'hbtrack/command/show_command'
require 'hbtrack/command/update_command'
require 'hbtrack/command/remove_command'
require 'hbtrack/command/add_command'
require 'hbtrack/command/import_command'

module Hbtrack
  module CLI
    class << self
      def run(store_path = DB_PATH, args)
        command = case args.shift
                  when 'list'
                    ListCommand.new(store_path, args)
                  when 'show'
                    ShowCommand.new(store_path, args)
                  when 'done'
                    UpdateCommand.new(store_path, args, true)
                  when 'undone'
                    UpdateCommand.new(store_path, args, false)
                  when 'remove'
                    RemoveCommand.new(store_path, args)
                  when 'add'
                    AddCommand.new(store_path, args)
                  when 'import'
                    ImportCommand.new(store_path, args)
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
        puts '     show: Show habit'
        puts '     done: Mark habit(s) as done'
        puts '     undone: Mark habit(s) as undone'
        puts '     import: Import data from files'
        puts
        puts 'Options:'
        puts "     -h, --help\t\tShow help messages of the command"
        exit
      end
    end
  end
end
