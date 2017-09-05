# frozen_string_literal: true

require 'test_helper'
require 'date'

class TestHabitTracker < MiniTest::Test
  def setup
    @habit_tracker = Hbtrack::HabitTracker.new(
      Hbtrack::TEST_FILE,
      Hbtrack::OUTPUT_FILE
    )
    @habit_tracker.habits.each(&:done)

    @done_count = @habit_tracker.habits.count
    @undone_count = (Date.today.day - 1) * 2
    @total = @done_count + @undone_count
  end

  def test_find_longest_name
    assert_equal 'workout', @habit_tracker.longest_name
  end

  def test_total_habits_stat
    stat = { done: @done_count, undone: @undone_count }
    assert_equal stat, @habit_tracker.total_habits_stat
  end

  def test_overall_stat_description
    expected_output = Hbtrack::Util.title 'Total'
    expected_output += "All: #{@total}, Done: #{@done_count}, " \
                        "Undone: #{@undone_count}"
    assert_equal expected_output, @habit_tracker.overall_stat_description
  end
end
