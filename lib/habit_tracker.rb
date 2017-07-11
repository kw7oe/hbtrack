# frozen_string_literal: true

require_relative 'habit'
require_relative 'cli'
require_relative 'config'

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

  def initialize(file = Config::FILE_NAME, 
                 output = Config::FILE_NAME)
    @habits = []
    @file_name = file
    @output_file_name = output
    initialize_habits_from_file
  end

  def parse_arguments(args)
    send(args.shift, args.join(','))
  end

  def method_missing(_m, *_args)
    HabitTracker.help
  end

  # This methods find a habit based on the name given.
  # Blocks are executed when habit is not found.
  def find(habit_name)
    habit = @habits.find do |h|
      h.name == habit_name
    end
    yield if habit.nil?
    habit
  end

  def longest_name
    @habits.max_by(&:name_length).name
  end

  private

  def initialize_habits_from_file
    return unless File.exist?(@file_name)
    input = File.read(@file_name).split(/\n\n/)
    input.each { |string| @habits << Habit.initialize_from_string(string) }
  end

  def list(habit_name = nil)
    habit = find(habit_name) do
      @habits.each_with_index do |h, index|
        space = longest_name.length - h.name_length
        puts "#{index + 1}. #{h.pretty_print_latest(space)}"
      end
      return
    end
    puts habit.pretty_print_all
  end

  def add(habit_name)
    @habits << Habit.new(habit_name)
    save
    puts CLI.green("#{habit_name} added succesfully!") # Similar code
  end

  def done(habit_name)
    habit = find_or_create(habit_name)
    habit.done
    save
    puts CLI.green("Done #{habit_name}!") # Similar code
  end

  def undone(habit_name)
    habit = find(habit_name) { raise_habit_not_found }
    habit.done(false)
    save
    puts CLI.blue("Undone #{habit_name}!") # Similar code
  end

  def remove(habit_name)
    habit = find(habit_name) { raise_habit_not_found }
    @habits.delete(habit)
    save
    puts CLI.blue("#{habit_name} removed!") # Similar code
  end

  def find_or_create(habit_name)
    habit = find(habit_name) do
      habit = Habit.new(habit_name)
      @habits << habit
    end
    habit
  end

  def raise_habit_not_found
    puts CLI.red "#{habit_name} not found."
  end

  def save
    File.open(@output_file_name, 'w') do |f|
      @habits.each do |habit|
        f.puts habit
      end
    end
  end
end
