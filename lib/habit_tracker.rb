require_relative 'habit'

class HabitTracker
  attr_reader :habits

  def initialize(file)
    @raw_input = []
    @habits = []
    @input = []
    File.open(file, 'r') do |f|
      f.each_line do |line|
        @raw_input << line
      end
    end
    parse
    generate
  end

  def generate
    @input.each_with_index do |data, index|
      @habits << Habit.new(index, data)
    end
  end

  def parse
    @input = @raw_input.map do |data|
      data.lstrip.chomp
    end
  end
end
