require_relative 'habit'

class HabitTracker
  attr_reader :habits

  def initialize(habits)
    @habits = []
    generate_habits(habits)
  end

  def list_habits
    string = ""
    @habits.each_with_index do |name, index|
      string << "#{index+1}. #{name}\n"
    end
    return string
  end

  private

  def generate_habits(habits)
    habits.each do |data|
      @habits << Habit.new(data)
    end
  end
end
