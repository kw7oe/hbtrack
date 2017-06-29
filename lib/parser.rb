require_relative 'habit_tracker'
class Parser
  attr_reader :habits
  def initialize(file)
    @habits = []
    @raw_input = []
    get_raw_input(file)
    parse
  end

  private

  def get_raw_input(file)
    File.open(file, 'r') do |f|
      f.each_line { |line| @raw_input << line }
    end
  end

  def parse_habit(pos)
    while @raw_input[pos] =~ /  \w/
      @habits << @raw_input[pos].lstrip.chomp
      pos += 1
    end
  end

  def parse
    pos = 0
    while @raw_input[pos] =~ /habit_tracker:/
      pos += 1
      puts @raw_input[pos]
      parse_habit(pos)
    end
  end
end
