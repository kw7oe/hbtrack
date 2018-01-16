# frozen_string_literal: true

require 'hbtrack/util'

module Hbtrack
  module CLI
    module View
      extend self

      # Create the string representation of
      # the habits and its entries to be presented
      # to the user
      def print_habits(habits, entries)
      end

      # Create the string representation of
      # a habit and its entries to be presented
      # to the user
      def print_habit(habit, entry)
      end

      # Create the string representation of
      # a entry to be presented to the user
      def convert_entry_to_view(entry)
        entry.map { |e| convert_status_to_view(e[:type]) }.join
      end

      # Create the string representation of
      # a status and colorized it accordingly
      def convert_status_to_view(status)
        return Util.green '*' if status.start_with? 'completed'
        return Util.red '*'
      end

    end
  end
end
