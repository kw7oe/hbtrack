# frozen_string_literal: true

require 'optparse'
require 'hbtrack/command'

module Hbtrack
  class UpdateCommand < Command
    def initialize(hbt, options, is_done)
      @day = DateTime.now
      @is_done = is_done
      @db = false
      super(hbt, options)
    end

    def execute
      return update_all_in_db(local_store, @day, @is_done) if @all
      return update_in_db(local_store, @names, @day, @is_done)
      super
    end

    def create_option_parser
      action = @is_done ? 'Done' : 'Undone'
      OptionParser.new do |opts|
        opts.banner = "Usage: hbtrack #{action.downcase} [<habit_name>] [options]"
        opts.separator ''
        opts.separator 'Options:'

        opts.on('-a', '--all', "#{action} all habits") do
          @all = true
        end

        opts.on('--day DAY', Integer, "#{action} habit(s) for specific day") do |day|
          @day = Date.new(Date.today.year, Date.today.month, day.to_i)
        end

        opts.on('-h', '--help', 'Prints this help') do
          puts opts
          exit
        end
      end
    end

    def update_in_db(store, name, day, is_done)
      id = store.get_habit_id_for(name)
      return ErrorHandler.raise_habit_not_found(name) unless id

      add_or_update_entry(store, id, day, is_done)
      Hbtrack::Util.green("Update successfully!")
    end

    def update_all_in_db(store, day, is_done)
      habits = store.get_all_habits
      habits.each do |h|
        add_or_update_entry(store, h[:id], day, is_done)
      end
      Hbtrack::Util.green("Update successfully!")
    end

    def add_or_update_entry(store, id, day, is_done)
      entry = store.get_latest_entry_of(id)
      type = is_done ? 'completed' : 'missed'
      unless entry_exist?(entry, day)
        entry = Hbtrack::Database::Entry.new(DateTime.now, type)
        store.add_entry_of(id, entry)
      else
        store.update_entry_of(id, day, type)
      end
    end

    # Check if the entry timestamp are within
    # the same day
    def entry_exist?(entry, day)
      return false unless entry
      year, month , day = extract_date(day)
      time = entry[:timestamp]
      y, m, d = extract_date(time)
      return y == year && m == month && d == day
    end

    # Extract out the year, month and day of
    # a Date or Time object.
    def extract_date(day)
      [day.year, day.month, day.day]
    end

    private
    def action(is_done)
      is_done ? 'Done' : 'Undone'
    end
  end
end
