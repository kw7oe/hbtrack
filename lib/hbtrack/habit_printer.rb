# frozen_string_literal: true

require 'hbtrack/util'

module Hbtrack
  # This class contains the methods that
  # are used to format the progress of a Habit
  # into string
  class HabitPrinter
    attr_accessor :formatter

    def initialize(formatter = CompleteSF.new)
      @formatter = formatter
    end

    def calculate_space_needed_for(habit, key)
      habit.longest_month.length - Util.get_month_from(key).length
    end

    def print_latest_progress(habit, no_of_space = 0)
      habit.name.to_s + ' ' * no_of_space + ' : ' +
        print_progress(
          habit.latest_progress,
          habit.latest_stat
        )
    end

    def print_all_progress(habit)
      habit.progress.map do |key, value|
        space = calculate_space_needed_for(habit, key)
        Util.convert_key_to_date(key, space) +
          print_progress(
            value,
            habit.stat_for_progress(key)
          )
      end.join("\n")
    end

    def print_progress(progress, stat)
      output = progress.split('').map do |x|
        if x == '0'
          Util.red('*')
        elsif x == '1'
          Util.green('*')
        else
          ' '
        end
      end.join('')
      output + ' ' * (32 - progress.size) +
        @formatter.format(stat)
    end
  end
end
