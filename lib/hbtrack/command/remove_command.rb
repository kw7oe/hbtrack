# frozen_string_literal: true

require 'optparse'
require 'hbtrack/command'

module Hbtrack
  class RemoveCommand < Command
    def initialize(store_path, options)
      super(store_path, options)
    end

    def execute
      return remove_from_db(@names, local_store)
      super
    end

    def create_option_parser
      OptionParser.new do |opts|
        opts.banner = 'Usage: hbtrack remove [<habit_name>]'
      end
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
