# frozen_string_literal: true

require 'optparse'
require 'hbtrack/command'

module Hbtrack
  # AddCommand class is responsible for handling
  # `hbtrack add` command in CLI
  class AddCommand < Command
    def initialize(store_path, options)
      super(store_path, options)
    end

    def execute
      unless @names.empty?
        return add_to_db(@names, local_store)
      end
      super
    end

    def create_option_parser
      OptionParser.new do |opts|
        opts.banner = 'Usage: hbtrack add [<habit_name>]'
      end
    end

    def feedback(names, added)
      output = []

      unless added.empty?
        output << Hbtrack::Util.green("Add #{added.join(',')}!")
        output << "\n"
        names -= added
      end

      unless names.empty?
        output << Hbtrack::Util.blue("#{names.join(',')} already existed!")
      end

      output.join
    end

    def add_to_db(names, store)
      order = store.get_habits_count
      names.each do |name|
        order = order + 1
        habit = Hbtrack::Database::Habit.new(name, order)
        store.add_habit(habit)
      end
      feedback(names, names)
    end

  end
end
