# frozen_string_literal: true

require_relative 'habit'
require_relative 'cli'
require_relative 'config'

# This class contains the methods to
# handle the operation of mutliple habits
class HabitTracker
  attr_reader :habits

  def initialize(file = Config::FILE_NAME, output = Config::FILE_NAME)
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

  def self.help
    puts 'usage: ruby hb.rb list'
    puts '       ruby hb.rb add habit_name'
    puts '       ruby hb.rb done habit_name'
  end

  private

  def initialize_habits_from_file
    return unless File.exist?(@file_name)
    input = File.read(@file_name).split(/\n\n/)
    input.each { |string| @habits << Habit.initialize_from_string(string) }
  end

  def list(_args)
    @habits.each_with_index do |habit, index|
      puts "#{index + 1}. #{habit.name}"
    end
  end

  def add(habit_name)
    @habits << Habit.new(habit_name)
    save
  end

  def done(habit_name)
    habit = find_or_create(habit_name)
    habit.done(Date.today)
    save
  end

  def remove(habit_name)
    habit = find(habit_name)
    @habits.delete(habit)
    save
  end

  def find(habit_name)
    @habits.find { |habit| habit.name == habit_name }
  end

  def find_or_create(habit_name)
    habit = find(habit_name)
    if habit.nil?
      habit = Habit.new(habit_name)
      @habits << habit
    end
    habit
  end

  def save
    File.open(@output_file_name, 'w') do |f|
      @habits.each do |habit|
        f.puts habit
      end
    end
  end
end
