# frozen_string_literal: true

require 'test_helper'
require 'date'

class TestHabit < MiniTest::Test
  def setup
    @habit = Hbtrack::Habit.new('Workout')
    @cli = Hbtrack::CLI
  end

  def initialize_habit_from_string
    string = <<~EOF
      workout
      2017,5: 0000000000011111
      2017,6: 0000000000011111
      2017,7: 1
    EOF
    @habit = Hbtrack::Habit.initialize_from_string(string) 
  end

  def test_initialize_from_string
    initialize_habit_from_string
    assert @habit
  end

  def test_name
    assert_equal 'Workout', @habit.name
  end

  def test_name_length
    assert_equal 7, @habit.name_length
  end

  def test_done_with_default_progress
    @habit.done
    assert_equal ' ' + '0' * (Date.today.day - 1) + '1',
                 @habit.latest_progress
  end

  def test_done_with_initial_progress
    date = Date.new(2017, 6, 17)
    key = Hbtrack::Habit.get_progress_key_from(date)
    @habit = Hbtrack::Habit.new('Workout', key => ' 0010')
    @habit.done(true, date)
    expected_result = ' 00100000000000001'
    assert_equal expected_result, @habit.progress[key]
  end

  def test_undone_with_default_progress
    @habit.done(false)
    assert_equal ' ' + '0' * Date.today.day,
                 @habit.latest_progress
  end

  def test_done_and_undone
    @habit.done(false)
    expected_result = ' ' + '0' * Date.today.day
    assert_equal expected_result, @habit.latest_progress
    @habit.done(true)
    assert @habit.latest_progress.end_with? '1'
  end

  def test_progress_output
    @habit.done
    key = Hbtrack::Habit.get_progress_key_from(Date.today)
    assert_equal "#{key}:#{@habit.progress[key]}\n",
                 @habit.progress_output
  end

  def test_multple_progress_output
    key1 = Hbtrack::Habit.get_progress_key_from(
      Date.new(2017, 4, 9)
    )
    key2 = Hbtrack::Habit.get_progress_key_from(
      Date.new(2017, 5, 10)
    )
    @habit = Hbtrack::Habit.new('Workout',
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

  def test_intialize_from_string_equal_to_s
    string = <<~EOF
      workout
      2017,5: 0000000000011111
      2017,6: 0000000000011111
      2017,7: 1

    EOF
    assert_equal string, Hbtrack::Habit.initialize_from_string(string).to_s
  end

  def test_pretty_print_progress
    expected_result = @cli.red('*') * 3 + @cli.green('*')
    assert_equal expected_result,
                 @habit.pretty_print_progress('0001')
  end

  def test_pretty_print_latest
    @habit.done(Date.today)
    expected_result = 'Workout : ' + @cli.red('*') *
                                     (Date.today.day - 1) + @cli.green('*')
    assert_equal expected_result,
                 @habit.pretty_print_latest
  end

  def test_pretty_print_all
    initialize_habit_from_string
    progress = @cli.red('*') * 11 + Hbtrack::CLI.green('*') * 5
    expected_result = 'May 2017: ' + progress + "\n" \
                       'June 2017: ' + progress + "\n" \
                       'July 2017: ' + Hbtrack::CLI.green('*')
    assert_equal expected_result,
                 @habit.pretty_print_all
  end

  def test_progress_stat_for
    initialize_habit_from_string
    expected_result = { done: 5, undone: 11 }
    assert_equal expected_result, @habit.progress_stat_for("2017,5".to_sym)
  end

  def test_progress_stat_output
    initialize_habit_from_string
    expected_result = @cli.green("Done: 5") + "\n" +
                      @cli.red("Undone: 11") + "\n"
    assert_equal expected_result, @habit.progress_stat_output_for("2017,5".to_sym)
  end

  def test_progress_stat
    initialize_habit_from_string
    expected_result = "May 2017: \n" + 
                      @habit.progress_stat_output_for("2017,5".to_sym) +
                      "\n" + "June 2017: \n" +
                      @habit.progress_stat_output_for("2017,6".to_sym) +
                      "\n" + "July 2017: \n" +
                      @habit.progress_stat_output_for("2017,7".to_sym) 
    assert_equal expected_result, @habit.progress_stat
  end
end
