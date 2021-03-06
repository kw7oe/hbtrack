# frozen_string_literal: true

require 'optparse'
require 'hbtrack/command'
require 'hbtrack/cli/view'

module Hbtrack
  # ShowCommand class is responsible for handling
  # `hbtrack import` command in CLI
  class ShowCommand < Command
    def initialize(store_path, options)
      super(store_path, options)
    end

    def execute
      return show(local_store, @names[0]) if @names[0]
      super
    end

    def create_option_parser
      OptionParser.new do |opts|
        opts.banner = 'Usage: hbtrack show <habit_name>'
      end
    end

    def show(store, title)
      habit = store.get_habit_by_title(title)
      return ErrorHandler.raise_habit_not_found(title) unless habit

      entries = get_entries_from_db(store, habit)
      Hbtrack::CLI::View.show_habit(habit, entries)
    end

    def get_entries_from_db(store, habit)
      entries = store.get_entries_of(habit[:id]).all
      entries.group_by { |e| e[:timestamp].strftime('%Y-%m') }
    end
  end
end

