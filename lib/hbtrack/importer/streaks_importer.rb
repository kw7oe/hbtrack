# frozen_string_literal: true

require 'hbtrack/importer/abstract_importer'
require 'hbtrack/database/model'
require 'csv'

module Hbtrack
  module Importer
    class StreaksImporter < AbstractImporter
      Habit = Hbtrack::Database::Habit
      Entry = Hbtrack::Database::Entry

      # Import and parse the  CSV from Streaks
      def import_from(file)
        raise 'File not found' unless File.exist?(file)
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
          page = line.fetch('page').to_i
          display_order = line.fetch('display_order').to_i
          display_order = page * display_order
          @habits[id] = Habit.new(title, display_order)
        end
      end

      # Create entry
      def create_entry(task_id, line)
        date = line.fetch('entry_date') # Get Date of entry
        timestamp = line.fetch('entry_timestamp').split("T") # Get Time of entry
        # Create timestamp
        timestamp = DateTime.parse(date + "T" + timestamp[1]).to_s
        type = line.fetch('entry_type')
        @entries[task_id] = [] unless @entries[task_id]
        @entries[task_id] << Entry.new(timestamp, type)
      end

    end
  end
end

