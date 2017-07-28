# frozen_string_literal: true

module Hbtrack
  # This class contains the methods that 
  # are used to format the progress of a Habit
  # into string
  class StatFormatter

    class << self

      # Format in terms of the count of done and undone.
      # @param hash [Hash]
      # @option hash [String] :done total of done
      # @option hash [String] :undone total of undone
      # @return [String] formatted result
      def done_undone(hash)
        CLI.green("Done: #{hash[:done]}") + "\n" +
        CLI.red("Undone: #{hash[:undone]}")
      end

      # Format in terms of the total and the count of
      # done and undone.
      # @param hash [Hash]
      # @option hash [String] :done total of done
      # @option hash [String] :undone total of undone
      # @return [String] formatted result
      def complete(hash)
        total = hash[:done] + hash[:undone]
        "(All: #{total}, Done: #{hash[:done]}, Undone: #{hash[:undone]})"
      end

      # Format in terms of the completion rate of the habit.
      # @param hash [Hash]
      # @option hash [String] :done total of done
      # @option hash [String] :undone total of undone
      # @return [String] formatted result
      def completion_rate(hash)
        percentage = to_percentage(hash)[:done]
        "Completion rate: #{percentage}%"
      end

      # Convert the value in the hash into percentage
      # @param hash [Hash]
      # @option hash [String] :done total of done
      # @option hash [String] :undone total of undone
      # @return [Hash] formatted result
      def to_percentage(hash)
        total = hash[:done] + hash[:undone]
        done_p = hash[:done] / total.to_f * 100
        undone_p = hash[:undone] / total.to_f * 100
        { done: done_p, undone: undone_p }
      end
    end
  end
end

