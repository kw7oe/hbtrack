# frozen_string_literal: true

require 'hbtrack/util'

module Hbtrack
  # This class contains the methods to
  # handle the operation of mutliple habits
  class HabitTracker
    attr_accessor :habits
    attr_reader :hp, :output_file_name

    def initialize(file = FILE_NAME,
                   output = FILE_NAME)
      @habits = []
      @file_name = file
      @output_file_name = output
      initialize_habits_from_file
    end

    def initialize_habits_from_file
      return unless File.exist?(@file_name)
      input = File.read(@file_name).split(/\n\n/)
      input.each { |string| @habits << Habit.initialize_from_string(string) }
    end

    # This methods find a habit based on the name given.
    # Blocks are executed when habit is not found.
    def find(habit_name:, if_fail: nil)
      habit = @habits.find do |h|
        h.name == habit_name
      end
      if_fail.call if habit.nil? && !if_fail.nil?
      habit
    end

    def find_or_create(habit_name)
      habit = find habit_name: habit_name, if_fail: (proc do
        habit = create(habit_name)
        return habit
      end)
    end

    def longest_name
      @habits.max_by(&:name_length).name
    end

    def total_habits_stat_for(key:)
      @habits.each_with_object(done: 0, undone: 0) do |habit, stat|
        stat[:done] += habit.stat_for_progress(key)[:done]
        stat[:undone] += habit.stat_for_progress(key)[:undone]
      end
    end

    def done_count_for(date:)
      count_for(date, '1')
    end

    def undone_count_for(date:)
      count_for(date, '0')
    end

    def overall_stat_description_for(key:, formatter:)
      Util.title('Total') + formatter.format(
        total_habits_stat_for(key: key)
      )
    end

    def create(habit_name)
      unless invalid_habit_name?(habit_name)
        habit = Habit.new(habit_name)
        @habits << habit
        return habit
      end
      return ErrorHandler.raise_habit_name_too_long if habit_name && habit_name.length > 11

      ErrorHandler.raise_invalid_arguments
    end

    def invalid_habit_name?(habit_name)
      habit_name.nil? || habit_name =~ /\s+/ ||
        habit_name.length > 11
    end

    def invalid_key?(key)
      habits.empty? || !habits.first.progress.key?(key)
    end

    private

    def count_for(d, value)
      habits.reduce(0) do |a, habit|
        val = habit.done_for(date: d) == value ? 1 : 0
        a + val
      end
    end
  end
end
