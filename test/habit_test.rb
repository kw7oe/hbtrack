require "minitest/autorun"
require "minitest/pride"
require_relative "../lib/habit"

class TestHabitTracker < MiniTest::Test 

  def setup
    @habit = Habit.new("Workout")
  end

  def test_to_s
    assert_equal "Workout", @habit.to_s
  end

end