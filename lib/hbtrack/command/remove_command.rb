# frozen_string_literal: true

require 'optparse'
require 'hbtrack/command'
require 'hbtrack/store'

module Hbtrack
  class RemoveCommand < Command
    def initialize(hbt, options)
      super(hbt, options)
    end

    def execute
      return remove(@name) if @name
      super
    end

    def create_option_parser
      OptionParser.new do |opts|
        opts.banner = 'Usage: hbtrack remove [<habit_name>]'

        opts.on('-h', '--help', 'Prints this help') do
          puts opts
          exit
        end
      end
    end

    def remove(name)
      habit = @hbt.find(name) do
        ErrorHandler.raise_if_habit_error(habit_name) 
        exit
      end
      
      @hbt.habits.delete(habit)

      Store.new(@hbt.habits, @hbt.output_file_name).save
      Hbtrack::Util.blue("Remove #{name}!")
    end

  end
end
