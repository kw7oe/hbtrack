# frozen_string_literal: true

module Hbtrack
  module Importer
    class HbtrackImporter < AbstractImporter

      def initialize
        super
      end

      # Import and parse the CSV from Streaks
      def import_from(file)
        return unless File.exist?(file)
        input = File.read(file).split(/\n\n/)
        input.each { |string| extract_from(string) }

        [@habits, @entries]
      end

      private
      def extract_from(string)
      end

      def find_or_create_habit(habit)
      end
    end
  end
end
