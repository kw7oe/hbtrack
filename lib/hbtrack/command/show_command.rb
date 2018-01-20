# frozen_string_literal: true

require 'optparse'
require 'hbtrack/command'

module Hbtrack
  # ShowCommand class is responsible for handling
  # `hbtrack import` command in CLI
  class ShowCommand < Command
    def initialize(file_path = 'hbtrack.db', options)
      # To allow creation of test.db
      @store = Hbtrack::Database::SequelStore.new(name: file_path)
      super(nil, options)
    end

    def execute
      return show(local_store, @names[0])
      super
    end

    def create_option_parser
      OptionParser.new do |opts|
        opts.banner = 'Usage: hbtrack show <habit_name>'
      end
    end

    def show(store, title)
      habit, entries = get_habit_from_db(store, title)
    end

    def get_habit_from_db(store, title)
      entry = {}
      habit = store.get_habit_by_title(title)
      entries = store.get_entries_of(habit[:id]).all
      entries = entries.group_by { |e| e[:timestamp].strftime('%Y-%m') }
      [habit, entries]
    end
  end
end

