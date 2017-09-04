# frozen_string_literal: true

require 'test_helper'

class TestListCommand < MiniTest::Test
  def setup
    @hbt = Hbtrack::HabitTracker.new(
      Hbtrack::TEST_FILE,
      Hbtrack::OUTPUT_FILE
    )
    @hbt.habits.each(&:done)
    @command = Hbtrack::ListCommand.new(@hbt, ['-a'])
  end

  def test_execute_single_habit
    @command = Hbtrack::ListCommand.new(@hbt, ['workout', '-p'])
    expected_result = @command.list(
      'workout',
      Hbtrack::HabitPrinter.new(Hbtrack::CompletionRateSF.new)
    )
    assert_equal expected_result, @command.execute
  end

  def test_execute_all_habit
    expected_result = @command.list_all(Hbtrack::HabitPrinter.new)
    assert_equal expected_result, @command.execute
  end

  def test_execute_nothing
    @command = Hbtrack::ListCommand.new(@hbt, [])
    expected_result = @command.help
    assert_equal expected_result, @command.execute
  end

  def test_list
    habit = @hbt.find('workout')
    expected_result = Hbtrack::Util.title 'workout'
    expected_result +=
      @command.printer.print_all_progress(habit) + "\n\n"
    expected_result += habit.overall_stat_description(Hbtrack::CompleteSF.new)
    assert_equal expected_result,
                 @command.list('workout', Hbtrack::HabitPrinter.new)
  end

  def test_list_all
    expected_result = Hbtrack::Util.title Date.today.strftime('%B %Y').to_s
    expected_result += '1. ' +
                       @command.printer.print_latest_progress(@hbt.habits[0]) + "\n"
    expected_result += '2. ' +
                       @command.printer.print_latest_progress(@hbt.habits[1], 3) + "\n\n"
    expected_result += @hbt.overall_stat_description
    assert_equal expected_result,
                 @command.list_all(Hbtrack::HabitPrinter.new)
  end
end
