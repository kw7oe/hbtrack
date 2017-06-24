require_relative 'habit'

class HabitTracker
  attr_reader :habits

  def initialize(habits)
    @habits = []
    generate_habit(habits)
  end

  private
  def generate_habit(habits)
    habits.each_with_index do |data, index|
      @habits << Habit.new(index, data)
    end
  end

  
end
