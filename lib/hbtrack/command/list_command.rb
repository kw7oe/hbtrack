# frozen_string_literal: true

require 'optparse'
require 'hbtrack/command'
require 'hbtrack/cli/view'

module Hbtrack
  class ListCommand < Command
    attr_reader :printer, :formatter, :month

    def initialize(hbt, options)
      @percentage = false
      @month = Date.today.strftime("%Y,%-m").to_sym

      super(hbt, options)
      @formatter = @percentage ? CompletionRateSF.new : CompleteSF.new
    end

    def execute
      return list_from_db(local_store, @names)
      super
    end

    def create_option_parser
      OptionParser.new do |opts|
        opts.banner = 'Usage: hbtrack list [<habit_name>] [options]'
        opts.separator ''
        opts.separator 'Options:'

        opts.on('-p', '--percentage', 'List habit(s) with completion rate') do
          @percentage = true
        end

        # TODO: Renamed to better describe the functionality
        #       as in this case user are required toe enter
        #       the input in the form of <year>,<month>
        opts.on('-m', '--month MONTH', 'List habit(s) according to month provided') do |month|
          @month = month.to_sym
          @year, @mon = month.split(',')
        end

        opts.on_tail('-h', '--help', 'Prints this help') do
          puts opts
          exit
        end
      end
    end

    def list_from_db(store, names)
      habits = []
      habits, entries = get_habits_from_db(store)
      Hbtrack::CLI::View.list_all_habits(habits, entries, @month)
    end

    def get_habits_from_db(store)
      habits = []
      entries = {}
      habits = store.get_all_habits
      habits.each do |habit|
        entries[habit[:title]] = get_entry_from_db(store, habit[:id])
      end
      [habits, entries]
    end

    def get_entry_from_db(store, id)
      month = @mon.to_i >= 1 ? @mon.to_i : Date.today.month
      year = @year.to_i >= 1 ? @year.to_i : Date.today.year
      store.get_entries_of_month(id, month, year)
    end

  end
end
