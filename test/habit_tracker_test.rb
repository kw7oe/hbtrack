# frozen_string_literal: true

require 'minitest/autorun'
require 'date'
require_relative '../lib/habit_tracker'
require_relative '../lib/config'

class TestHabitTracker < MiniTest::Test
  def setup
    @habit_tracker = HabitTracker.new(
      Config::TEST_FILE,
      Config::OUTPUT_FILE
    )
  end

  def test_habit_tracker_find_longest_name
    assert_equal 'workout', @habit_tracker.longest_name
  end

  def test_habit_tracker_list_all
    progress = CLI.green('*')
    expected_result = '1. workout : ' + progress + "\n"
    expected_result += '2. read    : ' + progress + "\n"
    assert_output expected_result do
      @habit_tracker.parse_arguments(['list'])
    end
  end

  def test_habit_tracker_list_workout
    expected_output = @habit_tracker.habits[0].pretty_print_all + "\n"
    assert_output expected_output do
      @habit_tracker.parse_arguments(%w[list workout])
    end
  end

  def test_habit_tracker_add
    expected_output = CLI.green('learning added succesfully!') + "\n"
    assert_output expected_output do
      @habit_tracker.parse_arguments(%w[add learning])
    end
    assert_equal 'learning', @habit_tracker.habits.last.name
  end

  def test_habit_tracker_done
    expected_output = CLI.green('Done read!') + "\n"
    assert_output expected_output do
      @habit_tracker.parse_arguments(%w[done read])
    end
  end

  def test_habit_tracker_undone
    expected_output = CLI.blue('Undone workout!') + "\n"
    assert_output expected_output do
      @habit_tracker.parse_arguments(%w[undone workout])
    end
  end

  def test_habit_tracker_remove
    expected_output = CLI.blue('read removed!') + "\n"
    assert_output expected_output do
      @habit_tracker.parse_arguments(%w[remove read])
    end
    assert_equal 1, @habit_tracker.habits.length
  end
end
