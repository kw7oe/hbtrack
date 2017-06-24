require_relative 'lib/habit_tracker'
module Journal
  def self.run
    puts 'Running...'
    @habit_tracker = HabitTracker.new('test.habit')
    puts @habit_tracker.habits
  end
end

Journal.run
