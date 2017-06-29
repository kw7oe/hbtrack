require "minitest/autorun"
require "minitest/pride"
require_relative "../lib/habit_tracker"

class TestHabit < MiniTest::Test 

  def setup
    @habit_tracker = HabitTracker.new(["Workout", "Read", "Programming"])
  end

  def test_habits_length
    assert_equal 3, @habit_tracker.habits.length
  end

  def test_list_habits
    result = <<-EOS
1. Workout
2. Read
3. Programming
    EOS
    assert_equal result, @habit_tracker.list_habits
  end

end