# frozen_string_literal: true

require_relative "habit"
# This class contains the methods to 
# handle the command line arguments
class CLI

  attr_reader :habits

  def initialize() 
    @habits = []
  end

  def parse_arguments(args)
    case args[0]
    when "list"
      list
    when "add"
      add(args[1])
    when "done"
      done(args[1])
    else
      puts "usage: ruby hb.rb add habit_name"
      puts "       ruby hb.rb done habit_name"
    end
  end

  private 
  def list 
    @habits.each_with_index { |habit, index| puts "#{index+1}. #{habit.name}" }
  end

  def add(name) 
    @habits << Habit.new(name)
  end

  def done(name)
    @habits.select { |habit| habit.name == name }.first.done
  end

end
