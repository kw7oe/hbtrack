# frozen_string_literal: true

require_relative 'habit'

# HabitTracker contains the public API
# to handle multiple habits. It
# is designed to work closely with Habit.
class HabitTracker
  attr_reader :habits

  def initialize(habits)
    @habits = []
    generate_habits(habits)
  end

  def list_habits
    @habits.each_with_index.inject('') do |acc, (habit, i)|
      acc + "#{i + 1}. #{habit.name}\n"
    end
  end

  private

  def generate_habits(habits)
    habits.each do |data|
      @habits << Habit.new(data)
    end
  end
end
