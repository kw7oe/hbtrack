# frozen_string_literal: true

require_relative 'habit'
# This class contains the methods to
# handle the command line arguments
class CLI
  attr_reader :habits

  def initialize
    @habits = []
    get_habits
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
  def get_habits
    input = File.read("test_data").split(/\n\n/) 
    input.each { |string| @habits << Habit.initialize_from_string(string) }
  end

  def list(args)
    @habits.each_with_index do |habit, index|
      puts "#{index + 1}. #{habit.name}"
    end
  end

  def add(habit_name)
    @habits << Habit.new(habit_name)
    save
  end

  def done(habit_name)
    @habits.select do |habit|
      habit.name == habit_name
    end.first.done
    save
  end

  def save
    File.open("habit_stat", "w") do |f|
      @habits.each do |habit|
        f.puts habit
      end
    end
  end
end
