# frozen_string_literal: true

module Hbtrack
  # This class contains the methods that 
  # are used to format the progress of a Habit
  # into string
  class StatFormatter

    class << self
      def done_undone(hash)
        CLI.green("Done: #{hash[:done]}") + "\n" +
        CLI.red("Undone: #{hash[:undone]}")
      end

      def complete(hash)
        total = hash[:done] + hash[:undone]
        "(All: #{total}, Done: #{hash[:done]}, Undone: #{hash[:undone]})"
      end
    end
  end
end

