require "minitest/autorun"
require "minitest/pride"
require "Date"
require_relative "../lib/habit"

class TestHabitTracker < MiniTest::Test 

  def setup
    @habit = Habit.new("Workout")
  end

  def test_to_s
    assert_equal "Workout", @habit.to_s
  end

  def test_done_with_default_progress
    @habit.done(Date.today)
    assert_equal "0" * (Date.today.day - 1) + "1", @habit.progress[:"2017,6"]
  end

  def test_done_with_initial_progress
    @habit = Habit.new("Workout", {"2017,6": "0010"})
    @habit.done(Date.new(2017, 6, 17))
    expected_result = "00100000000000001"
    assert_equal expected_result, @habit.progress[:"2017,6"]
  end
end
