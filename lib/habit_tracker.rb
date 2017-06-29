require_relative 'habit'

class HabitTracker
  attr_reader :habits

  def initialize(habits)
    @habits = []
    generate_habit(habits)
  end

  def list_habits
    string = ""
    @habits.each_with_index do |name, index|
      string << "#{index+1}. #{name}\n"
    end
    return string
  end

  private

  def generate_habit(habits)
    habits.each do |data|
      @habits << Habit.new(data)
    end
  end
end
