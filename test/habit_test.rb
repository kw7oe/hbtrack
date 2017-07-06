# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require 'Date'
require_relative '../lib/habit'
require_relative '../lib/cli'

class TestHabit < MiniTest::Test
  def setup
    @habit = Habit.new('Workout')
    @habit.done(Date.today)
  end

  def test_initialize_from_string
    string = <<~EOF
      workout
      2017,5: 0001000000100010
      2017,6: 0001000000100010
      2017,7: 1

    EOF
    assert_equal string, Habit.initialize_from_string(string).to_s
  end

  def test_name
    assert_equal 'Workout', @habit.name
  end

  def test_name_length
    assert_equal 7, @habit.name_length
  end

  def test_done_with_default_progress
    key = Habit.get_progress_key_from(Date.today)
    assert_equal ' ' + '0' * (Date.today.day - 1) + '1', @habit.progress[key]
  end

  def test_done_with_initial_progress
    date = Date.new(2017, 6, 17)
    key = Habit.get_progress_key_from(date)
    @habit = Habit.new('Workout', key => ' 0010')
    @habit.done(date)
    expected_result = ' 00100000000000001'
    assert_equal expected_result, @habit.progress[key]
  end

  def test_progress_output
    key = Habit.get_progress_key_from(Date.today)
    assert_equal "#{key}:#{@habit.progress[key]}\n", @habit.progress_output
  end

  def test_multple_progress_output
    key1 = Habit.get_progress_key_from(Date.new(2017, 4, 9))
    key2 = Habit.get_progress_key_from(Date.new(2017, 5, 10))
    @habit = Habit.new('Workout',
                       key1 => ' 00010',
                       key2 => ' 11101')
    expected_result = <<~EOF
      2017,4: 00010
      2017,5: 11101
    EOF
    assert_equal expected_result, @habit.progress_output
  end

  def test_to_s
    assert_equal "Workout\n#{@habit.progress_output}\n", @habit.to_s
  end

  def test_pretty_print_progress
    expected_result = CLI.red("*") * 3 + CLI.green("*")
    assert_equal expected_result, @habit.pretty_print_progress("0001")
  end

  def test_pretty_print
    expected_result = "Workout : " + CLI.red("*") * (Date.today.day - 1) + CLI.green("*")
    assert_equal expected_result, @habit.pretty_print
  end
end
