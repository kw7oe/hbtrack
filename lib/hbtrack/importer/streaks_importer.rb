# frozen_string_literal: true

require 'hbtrack/importer/abstract_importer'
require 'csv'

module Hbtrack
  module Importer
    class StreaksImporter < AbstractImporter
      # Data Abstraction for Streaks Domain
      Habit = Struct.new(:id, :title, :page, :display_order)
      Entry = Struct.new(:timestamp, :type, :habit_id)

      # Import and parse the  CSV from Streaks
      def import_from(file)
        CSV.foreach(file, headers: true) do |row|
          extract_streaks_data(row)
        end
        # Handle the parsed data
        [@habits, @entries]
      end

      private
      # Extract Streaks data from each line
      def extract_streaks_data(line)
        task_id = line.fetch('task_id')
        find_or_create_habit(task_id, line)
        create_entry(task_id, line)
      end

      # Find or create habit
      def find_or_create_habit(id, line)
        unless @habits.has_key? id
          title = line.fetch('title').strip
          page = line.fetch('page')
          display_order = line.fetch('display_order')
          @habits[id] = Habit.new(id, title, page, display_order)
        end
      end

      # Create entry
      def create_entry(task_id, line)
        timestamp = line.fetch('entry_timestamp')
        type = line.fetch('entry_type')
        @entries[task_id] = [] unless @entries[task_id]
        @entries[task_id] << Entry.new(timestamp, type)
      end

    end
  end
end

