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

  def test_add
    expected_output = Hbtrack::Util.green('Add learning!') + "\n"
    assert_output expected_output do
      @habit_tracker.parse_arguments(%w[add learning])
    end
    assert_equal 'learning', @habit_tracker.habits.last.name
  end

  def test_add_very_long_name
    count = @habit_tracker.habits.count
    expected_output = Hbtrack::Util.red('habit_name too long.') + "\n"
    assert_output expected_output do
      @habit_tracker.parse_arguments(%w[add veryverylongname])
    end
    assert_equal @habit_tracker.habits.count, count
  end

  def test_add_blank
    expected_output = Hbtrack::Util.red('Invalid argument: ' \
                      'habit_name is expected.') + "\n"
    assert_output expected_output do
      @habit_tracker.parse_arguments(%w[add])
    end
  end

  def test_prevent_add_duplicate
    expected_output = Hbtrack::Util.blue('workout already existed!') + "\n"
    assert_output expected_output do
      @habit_tracker.parse_arguments(%w[add workout])
    end
    assert_equal 2, @habit_tracker.habits.size
  end

  def test_remove
    expected_output = Hbtrack::Util.blue('Remove read!') + "\n"
    assert_output expected_output do
      @habit_tracker.parse_arguments(%w[remove read])
    end
    assert_equal 1, @habit_tracker.habits.length
  end

  def test_remove_blank
    expected_output = Hbtrack::Util.red('Invalid argument: ' \
                      'habit_name is expected.') + "\n"
    assert_output expected_output do
      @habit_tracker.parse_arguments(%w[remove])
    end
  end

  def test_remove_invalid_habit
    expected_output = Hbtrack::Util.red('Invalid habit: ' \
                      'apple not found.') + "\n"
    assert_output expected_output do
      @habit_tracker.parse_arguments(%w[remove apple])
    end
  end
end
