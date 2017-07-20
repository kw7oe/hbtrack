# frozen_string_literal: true

require 'test_helper'
require 'date'

class TestHabitTracker < MiniTest::Test
  def setup
    @habit_tracker = Hbtrack::HabitTracker.new(
      Hbtrack::TEST_FILE,
      Hbtrack::OUTPUT_FILE
    )
  end

  def test_find_longest_name
    assert_equal 'workout', @habit_tracker.longest_name
  end

  def test_list_all
    progress = Hbtrack::CLI.green('*')
    expected_result = '1. workout : ' + progress + "\n"
    expected_result += '2. read    : ' + progress + "\n"
    assert_output expected_result do
      @habit_tracker.parse_arguments(['list'])
    end
  end

  def test_list_single_habit
    expected_output = @habit_tracker.habits[0].pretty_print_all + "\n"
    assert_output expected_output do
      @habit_tracker.parse_arguments(%w[list workout])
    end
  end

  def test_add
    expected_output = Hbtrack::CLI.green('Add learning!') + "\n"
    assert_output expected_output do
      @habit_tracker.parse_arguments(%w[add learning])
    end
    assert_equal 'learning', @habit_tracker.habits.last.name
  end

  def test_prevent_add_duplicate
    expected_output = Hbtrack::CLI.blue('workout already existed!') + "\n"
    assert_output expected_output do
      @habit_tracker.parse_arguments(%w[add workout])
    end
    assert_equal 2, @habit_tracker.habits.size
  end

  def test_done
    expected_output = Hbtrack::CLI.green('Done read!') + "\n"
    assert_output expected_output do
      @habit_tracker.parse_arguments(%w[done read])
    end
  end

  def test_done_yesterday
    expected_output = Hbtrack::CLI.green('Done read!') + "\n"
    assert_output expected_output do
      @habit_tracker.parse_arguments(%w[done -y read])
    end
  end

  def test_undone
    expected_output = Hbtrack::CLI.blue('Undone workout!') + "\n"
    assert_output expected_output do
      @habit_tracker.parse_arguments(%w[undone workout])
    end
  end

  def test_undone_yesterday
    expected_output = Hbtrack::CLI.blue('Undone read!') + "\n"
    assert_output expected_output do
      @habit_tracker.parse_arguments(%w[undone -y read])
    end
  end

  def test_remove
    expected_output = Hbtrack::CLI.blue('Remove read!') + "\n"
    assert_output expected_output do
      @habit_tracker.parse_arguments(%w[remove read])
    end
    assert_equal 1, @habit_tracker.habits.length
  end

  def test_remove_invalid_habit
    expected_output = Hbtrack::CLI.red('Invalid argument: ' +
                      'habit_not_exist not found.') + "\n"
    assert_output expected_output do
      @habit_tracker.parse_arguments(%w[remove habit_not_exist])
    end
  end
end
