# frozen_string_literal: true

require 'hb/version'
require 'hb/habit'
require 'hb/cli'
require 'hb/config'

module Hb
  # This class contains the methods to
  # handle the operation of mutliple habits
  class HabitTracker
    attr_reader :habits

    def self.help # Refactoring needed
      puts 'usage: ruby hb.rb list [ habit_name ]'
      puts '       ruby hb.rb add habit_name'
      puts '       ruby hb.rb done habit_name'
      puts '       ruby hb.rb undone habit_name'
    end

    def initialize(file = Hb::FILE_NAME,
                   output = Hb::FILE_NAME)
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

    private

    def initialize_habits_from_file
      return unless File.exist?(@file_name)
      input = File.read(@file_name).split(/\n\n/)
      input.each { |string| @habits << Hb::Habit.initialize_from_string(string) }
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
        @habits << Hb::Habit.new(habit_name)
        save
        puts Hb::CLI.green("#{habit_name} added succesfully!")
        return
      end
      puts Hb::CLI.blue("#{habit_name} already existed!")
    end

    def done(args)
      habit_name, options = parse_options(args)
      day = get_day_based_on(options)
      habit = find_or_create(habit_name)
      habit.done(true, day)
      save
      puts Hb::CLI.green("Done #{habit_name}!") # Similar code
    end

    def undone(args)
      habit_name, options = parse_options(args)
      day = get_day_based_on(options)
      habit = find(habit_name) { raise_habit_not_found }
      habit.done(false, day)
      save
      puts Hb::CLI.blue("Undone #{habit_name}!") # Similar code
    end

    def remove(args)
      habit_name, _options = parse_options(args)
      habit = find(habit_name) { raise_habit_not_found }
      @habits.delete(habit)
      save
      puts Hb::CLI.blue("#{habit_name} removed!") # Similar code
    end

    def find_or_create(habit_name)
      habit = find(habit_name) do
        habit = Hb::Habit.new(habit_name)
        @habits << habit
      end
      habit
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

    def raise_habit_not_found
      puts Hb::CLI.red "#{habit_name} not found."
    end

    def save
      File.open(@output_file_name, 'w') do |f|
        @habits.each do |habit|
          f.puts habit
        end
      end
    end
  end
end


