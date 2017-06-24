require_relative 'lib/habit_tracker'
require_relative 'lib/parser'
module Journal

  def self.run(file)
    parser = Parser.new(file)
    habit_tracker = HabitTracker.new(parser.habits)
  end  
end

Journal.run(ARGV[0])
