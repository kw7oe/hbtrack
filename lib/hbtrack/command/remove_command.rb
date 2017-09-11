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
      return remove(@names) if @names
      super
    end

    def create_option_parser
      OptionParser.new do |opts|
        opts.banner = 'Usage: hbtrack remove [<habit_name>]'
      end
    end

    def remove(names)
      names.each do |name|
        habit = @hbt.find(name) do
          return ErrorHandler.raise_if_habit_error(name)
        end

        @hbt.habits.delete(habit)
      end

      Store.new(@hbt.habits, @hbt.output_file_name).save
      Hbtrack::Util.blue("Remove #{names.join(',')}!")
    end
  end
end
