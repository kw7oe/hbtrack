# frozen_string_literal: true

require 'hbtrack/util'

module Hbtrack
  # This class contains the methods to
  # handle the operation of mutliple habits
  class HabitTracker
    attr_reader :habits, :hp, :output_file_name

    def initialize(file = FILE_NAME,
                   output = FILE_NAME)
      @habits = []
      @file_name = file
      @output_file_name = output
      @sf = CompleteSF.new
      @hp = HabitPrinter.new(@sf)
      initialize_habits_from_file
    end

    def initialize_habits_from_file
      return unless File.exist?(@file_name)
      input = File.read(@file_name).split(/\n\n/)
      input.each { |string| @habits << Habit.initialize_from_string(string) }
    end

    # This methods find a habit based on the name given.
    # Blocks are executed when habit is not found.
    def find(habit_name)
      habit = @habits.find do |h|
        h.name == habit_name
      end
      yield if habit.nil? && block_given?
      habit
    end

    def find_or_create(habit_name)
      habit = find(habit_name) do
        habit = create(habit_name)
        return habit
      end
    end

    def longest_name
      @habits.max_by(&:name_length).name
    end

    def method_missing(*_args)
      HabitTracker.help
    end

    def total_habits_stat
      @habits.each_with_object(done: 0, undone: 0) do |habit, stat|
        stat[:done] += habit.latest_stat[:done]
        stat[:undone] += habit.latest_stat[:undone]
      end
    end

    def overall_stat_description
      Util.title('Total') +
        @sf.format(total_habits_stat)
    end

    def create(habit_name)
      unless invalid_habit_name?(habit_name)
        habit = Habit.new(habit_name)
        @habits << habit
        return habit
      end

      if habit_name && habit_name.length > 11
        ErrorHandler.raise_habit_name_too_long
      else
        ErrorHandler.raise_invalid_arguments
      end
    end

    def invalid_habit_name?(habit_name)
      habit_name.nil? || habit_name =~ /\s+/ ||
        habit_name.length > 11
    end
  end
end
