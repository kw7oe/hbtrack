# frozen_string_literal: true

require 'hbtrack/util'

module Hbtrack
  # This is an abstract class for classes that
  # are used to format the progress of a Habit
  # into string
  class StatFormatter
    def initialize; end

    def format
      raise 'Not Implemented'
    end
  end

  class DoneUndoneSF < StatFormatter
    # Format in terms of the count of done and undone.
    # @param hash [Hash]
    # @option hash [String] :done total of done
    # @option hash [String] :undone total of undone
    # @return [String] formatted result
    def format(hash)
      Util.green("Done: #{hash[:done]}") + "\n" +
        Util.red("Undone: #{hash[:undone]}")
    end
  end

  class CompleteSF < StatFormatter
    # Format in terms of the total and the count of
    # done and undone.
    # @param hash [Hash]
    # @option hash [String] :done total of done
    # @option hash [String] :undone total of undone
    # @return [String] formatted result
    def format(hash)
      total = hash[:done] + hash[:undone]
      "All: #{total}, Done: #{hash[:done]}, Undone: #{hash[:undone]}"
    end
  end

  class CompletionRateSF < StatFormatter
    # Format in terms of the completion rate of the habit.
    # @param hash [Hash]
    # @option hash [String] :done total of done
    # @option hash [String] :undone total of undone
    # @return [String] formatted result
    def format(hash)
      percentage = to_percentage(hash)[:done]
      sprintf('Completion rate: %.2f%', percentage)
    end

    # Convert the value in the hash into percentage
    # @param hash [Hash]
    # @option hash [String] :done total of done
    # @option hash [String] :undone total of undone
    # @return [Hash] formatted result
    def to_percentage(hash)
      total = hash[:done] + hash[:undone]
      done_p = 0
      undone_p = 0
      unless total.zero?
        done_p = hash[:done] / total.to_f * 100
        undone_p = hash[:undone] / total.to_f * 100
      end
      { done: done_p, undone: undone_p }
    end
  end
end
