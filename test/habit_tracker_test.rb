# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require 'Date'
require_relative '../lib/habit_tracker'
require_relative '../lib/config'

class TestHabitTracker < MiniTest::Test
  def setup
    @habit_tracker = HabitTracker.new(
      Config::TEST_FILE,
      Config::OUTPUT_FILE
    )
  end

  def test_habit_tracker_list
    assert_output "1. workout\n2. read\n" do
      @habit_tracker.parse_arguments(['list'])
    end
  end

  def test_habit_tracker_add
    @habit_tracker.parse_arguments(%w[add learning])
    assert_equal 'learning', @habit_tracker.habits.last.name
  end

  def test_habit_tracker_done
    @habit_tracker.parse_arguments(%w[add learning])
    @habit_tracker.parse_arguments(%w[done learning])
    assert_equal 1, @habit_tracker.habits.last.progress.length
  end

  def test_habit_tracker_remove
    @habit_tracker.parse_arguments(%w[remove read])
    assert_equal 1, @habit_tracker.habits.length
  end
end
