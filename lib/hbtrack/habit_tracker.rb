# frozen_string_literal: true

require 'hbtrack/util'

module Hbtrack
  # This class contains the methods to
  # handle the operation of mutliple habits
  class HabitTracker
    attr_reader :habits, :hp, :output_file_name

    def self.help # Refactoring needed
      puts 'usage: hbtrack list [-p] [ habit_name ]'
      puts '       hbtrack add habit_name'
      puts '       hbtrack done [-y] habit_name'
      puts '       hbtrack undone [-y] habit_name'
      puts '       hbtrack remove habit_name'
    end

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

    def parse_arguments(args)
      head = args.shift
      tail = args
      send(head, tail)
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

    private

    def add(args)
      habit_name, _options = parse_options(args)
      find(habit_name) do
        habit = create(habit_name)
        save_to_file(habit, 'Add') unless habit.nil?
        return
      end
      puts Util.blue("#{habit_name} already existed!")
    end

    def remove(args)
      habit_name, _options = parse_options(args)
      habit = find(habit_name) { ErrorHandler.raise_if_habit_error(habit_name) }
      save_to_file(habit, 'Remove', 'blue') do
        @habits.delete(habit)
      end
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

    def parse_options(args)
      options = args.select { |x| x =~ /\A-/ }
      args -= options
      [args[0], options]
    end

    def invalid_habit_name?(habit_name)
      habit_name.nil? || habit_name =~ /\s+/ ||
        habit_name.length > 11
    end

    def save
      File.open(@output_file_name, 'w') do |f|
        @habits.each do |habit|
          f.puts habit
        end
      end
    end

    def save_to_file(habit, action, color = 'green')
      unless habit.nil?
        yield if block_given?
        save
        name = if habit.is_a? Array
                 habit.map(&:name).join(', ')
               else
                 habit.name
               end
        output = "#{action} #{name}!"
        puts Util.public_send(color, output)
      end
    end
  end
end
