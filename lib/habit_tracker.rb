# frozen_string_literal: true

require_relative 'habit'
# This class contains the methods to
# handle the operation of mutliple habits
class HabitTracker
  attr_reader :habits

  def initialize(file)
    @habits = []
    get_habits_from(file)
  end

  def parse_arguments(args)
    send(args.shift, args.join(','))
  end

  def method_missing(_m, *_args)
    puts 'usage: ruby hb.rb list'
    puts '       ruby hb.rb add habit_name'
    puts '       ruby hb.rb done habit_name'
  end

  private

  def get_habits_from(file)
    return unless File.exist?(file)
    input = File.read(file).split(/\n\n/)
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

  def find(habit_name)
    @habits.select { |habit| habit.name == habit_name }.first
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
    File.open('habit_stat', 'w') do |f|
      @habits.each do |habit|
        f.puts habit
      end
    end
  end
end
