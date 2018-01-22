# frozen_string_literal: true

require 'hbtrack/util'

module Hbtrack
  module CLI
    module View
      extend self

      # Create the string output of command
      # `hbtrack list` a.k.a ListCommand.list_all
      def list_all_habits(habits, entries, month_key)
        date = Util.get_date_from(key: month_key)
        Util.title(date.strftime('%B %Y')) +
          print_habits(habits, entries)
     end

      def show_habit(habit, entries)
        Util.title(habit[:title]) +
          print_entries(entries)
      end

      # Create the string representation of
      # the habits and its entries to be presented
      # to the user
      def print_habits(habits, entries)
        char_count = max_char_count habits.map { |h| h[:title] }
        habits.map.with_index(1) do |habit, index|
          title = habit[:title]
          print_habit(index, title, entries[title], char_count - title.size)
        end.join("\n")
      end

      # Create the string representation of
      # a habit and its entries to be presented
      # to the user
      def print_habit(index, title, entry, space = 0)
        "#{index}. #{title}#{' ' * space} : " +
        convert_entry_to_view(entry)
      end

      # Create the string representation of
      # a hash of entries.
      def print_entries(entries)
        char_count = max_char_count entries.keys
        entries.map do |month, entry|
          print_entry(month, entry, char_count - month.size)
        end.join("\n")
      end

      # Create the string representation of
      # an entry with its date period. E.g
      # "Septemper 2017".
      def print_entry(period, entry, space)
        "#{period}#{' ' * space} : " + convert_entry_to_view(entry)
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

      # Iterate through an array of string
      # to find the largest character count
      # from the array of string.
      def max_char_count(strings)
        strings.map(&:size).max
      end
    end
  end
end
