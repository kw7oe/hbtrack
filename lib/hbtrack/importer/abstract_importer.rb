# frozen_string_literal: true

module Hbtrack
  module Importer
    class AbstractImporter

      def initialize
        @habits = {}
        @entries = {}
      end

      # Store in database
      def store_in(store)
        ids = {}
        @habits.each do |id, habit|
          ids[id] = store.add_habit(habit)
        end

        @entries.each do |key, entries|
          id = ids[key]
          entries.each do |entry|
            store.add_entry_of(id, entry)
          end
        end
      end

      # Import and parse the CSV from Streaks
      def import_from(file)
        raise 'Not implemented'
      end

    end
  end
end
