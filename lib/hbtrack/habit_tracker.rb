# frozen_string_literal: true

require 'hbtrack/version'
require 'hbtrack/habit'
require 'hbtrack/cli'
require 'hbtrack/config'

module Hbtrack
  # This class contains the methods to
  # handle the operation of mutliple habits
  class HabitTracker
    attr_reader :habits

    def self.help # Refactoring needed
      puts 'usage: hbtrack list [ habit_name ]'
      puts '       hbtrack add habit_name'
      puts '       hbtrack done [-y] habit_name'
      puts '       hbtrack undone [-y] habit_name'
      puts '       hbtrack remove habit_name'
    end

    def initialize(file = Hbtrack::FILE_NAME,
                   output = Hbtrack::FILE_NAME)
      @habits = []
      @file_name = file
      @output_file_name = output
      initialize_habits_from_file
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

    def longest_name
      @habits.max_by(&:name_length).name
    end

    def method_missing(_method_name, _arguments, _block)
      HabitTracker.help
    end

    private

    def initialize_habits_from_file
      return unless File.exist?(@file_name)
      input = File.read(@file_name).split(/\n\n/)
      input.each { |string| @habits << Hbtrack::Habit.initialize_from_string(string) }
    end

    def list(args)
      habit_name, _options = parse_options(args)
      habit = find(habit_name) do
        @habits.each_with_index do |h, index|
          space = longest_name.length - h.name_length
          puts "#{index + 1}. #{h.pretty_print_latest(space)}"
        end
        return
      end
      puts habit.pretty_print_all
    end

    def add(args)
      habit_name, _options = parse_options(args)
      find(habit_name) do
        habit = create(habit_name)
        save_to_file(habit, 'Add') unless habit.nil?
        return
      end
      puts Hbtrack::CLI.blue("#{habit_name} already existed!")
    end

    def done(args)
      habit_name, options = parse_options(args)
      day = get_day_based_on(options)
      habit = find_or_create(habit_name)
      save_to_file(habit, 'Done') do
        habit.done(true, day)
      end
    end

    def undone(args)
      habit_name, options = parse_options(args)
      day = get_day_based_on(options)
      habit = find(habit_name) { raise_habit_not_found(habit_name) }
      save_to_file(habit, 'Undone', 'blue') do
        habit.done(false, day)
      end
    end

    def remove(args)
      habit_name, _options = parse_options(args)
      habit = find(habit_name) { raise_habit_not_found(habit_name) }
      save_to_file(habit, 'Remove', 'blue') do
        @habits.delete(habit)
      end
    end

    def find_or_create(habit_name)
      habit = find(habit_name) do
        habit = create(habit_name)
        return habit
      end
    end

    def create(habit_name)
      unless valid_habit_name?(habit_name)
        habit = Hbtrack::Habit.new(habit_name)
        @habits << habit
        return habit
      end

      error_msg = 'Invalid argument: habit_name is expected.'
      if habit_name && habit_name.length > 11 
        error_msg = 'habit_name too long.'
      end
      puts Hbtrack::CLI.red(error_msg)
    end

    def parse_options(args)
      options = args.select { |x| x =~ /\A-/ }
      args -= options
      [args[0], options]
    end

    def get_day_based_on(options)
      return Date.today unless options[0] == '-y'
      Date.today - 1
    end

    def raise_habit_not_found(habit_name)
      last_words = habit_name ? 'not found' : 'is expected'
      habit_name ||= 'habit_name'
      puts Hbtrack::CLI.red "Invalid argument: #{habit_name} #{last_words}."
    end

    def valid_habit_name?(habit_name)
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
        output = "#{action} #{habit.name}!"
        puts Hbtrack::CLI.public_send(color, output)
      end
    end
  end
end
