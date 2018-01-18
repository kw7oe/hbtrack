# frozen_string_literal: true

require 'hbtrack/importer/abstract_importer'
require 'hbtrack/database/model'
require 'date'

module Hbtrack
  module Importer
    class HbtrackImporter < AbstractImporter
      Habit = Hbtrack::Database::Habit
      Entry = Hbtrack::Database::Entry

      ENTRY_TYPE = {
        '0' => 'missed',
        '1' => 'completed',
        ' ' => 'skip'
      }

      def initialize
        super
        @index = 1
      end

      # Import and parse the CSV from Streaks
      def import_from(file)
        raise 'File not found' unless File.exist?(file)
        input = File.read(file).split(/\n\n/)
        input.each_with_index do |collection, index|
          extract_from(index, collection)
        end

        [@habits, @entries]
      end

      def extract_from(id, collection)
        arr = collection.split("\n")

        # Get habit name
        habit_name = arr.shift
        @habits[id] = create_habit(habit_name)

        create_entries_of(id, arr)
      end

      # Create a Habit
      def create_habit(habit)
        habit = Habit.new(habit, @index)
        @index += 1
        habit
      end

      def create_entries_of(id, entries)
        @entries[id] = entries.flat_map do |entry|
          month, values = entry.split(': ')

          values.split("").map.with_index(1) do |value, index|
            create_entry(month, index, value)
          end
        end
      end

      def create_entry(month, day, value)
        timestamp = create_timestamp_for(month, day)
        type = ENTRY_TYPE[value]
        Entry.new(timestamp, type)
      end

      def create_timestamp_for(month, day)
        year, month = month.split(',').map(&:to_i)
        time_zone = Time.new.zone
        DateTime.new(year, month, day, 0, 0, 0, "#{time_zone}:00").to_s
      end

    end
  end
end
