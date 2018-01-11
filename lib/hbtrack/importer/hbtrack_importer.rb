# frozen_string_literal: true

require 'hbtrack/importer/abstract_importer'
require 'date'

module Hbtrack
  module Importer
    class HbtrackImporter < AbstractImporter
      Habit = Hbtrack::Importer::AbstractImporter::Habit
      Entry = Hbtrack::Importer::AbstractImporter::Entry

      ENTRY_TYPE = {
        '0' => 'missed',
        '1' => 'completed',
        ' ' => 'skip'
      }

      def initialize
        super
        @index = 1
        @id = 1
      end

      # Import and parse the CSV from Streaks
      def import_from(file)
        return unless File.exist?(file)
        input = File.read(file).split(/\n\n/)
        input.each { |block| extract_from(block) }

        [@habits, @entries]
      end

      def extract_from(block)
        arr = block.split("\n")

        # Get habit name
        habit_name = arr.shift
        id = create_habit(habit_name)

        create_entries_of(id, arr)
      end

      # Create a Habit and return its id.
      def create_habit(habit)
        id = @id
        @habits[id] = Habit.new(1, habit, 1, @index)
        @id += 1
        @index += 1

        id
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
        DateTime.new(year, month, day).to_s
      end

    end
  end
end
