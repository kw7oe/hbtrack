# frozen_string_literal: true

require 'optparse'
require 'hbtrack/command'
require 'hbtrack/store'

module Hbtrack
  class RemoveCommand < Command
    def initialize(hbt, options)
      @db = false
      super(hbt, options)
    end

    def execute
      return remove_from_db(@names, local_store) if @db
      return remove(@names) if @names
      super
    end

    def create_option_parser
      OptionParser.new do |opts|
        opts.banner = 'Usage: hbtrack remove [<habit_name>]'
        opts.on('--db', 'Remove habits from database') do
          @db = true
        end
      end
    end

    def remove(names)
      names.each do |name|
        habit = @hbt.find habit_name: name, if_fail: (proc do
          return ErrorHandler.raise_if_habit_error(name)
        end)

        @hbt.habits.delete(habit)
      end

      Store.new(@hbt.habits, @hbt.output_file_name).save
      feedback(names)
    end

    def feedback(names)
      Hbtrack::Util.blue("Remove #{names.join(',')}!")
    end

    def remove_from_db(names, store)
      status = store.delete_habit(names)
      return ErrorHandler.raise_if_habit_error(names) if status == 0

      feedback(names)
    end
  end
end
