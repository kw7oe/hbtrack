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

  def test_list
    habit = @hbt.find("workout")
    expected_output = Hbtrack::Util.title "workout"
    expected_output +=
      @hbt.hp.print_all_progress(habit) + "\n\n"
    expected_output += habit.overall_stat_description(Hbtrack::CompleteSF.new) + "\n"
    assert_output expected_output do 
      @command.list("workout", Hbtrack::HabitPrinter.new)
    end
  end
 
  def test_list_all
    expected_output = Hbtrack::Util.title Date.today.strftime('%B %Y').to_s
    expected_output += '1. ' +
                       @hbt.hp.print_latest_progress(@hbt.habits[0]) + "\n"
    expected_output += '2. ' +
                       @hbt.hp.print_latest_progress(@hbt.habits[1], 3) + "\n\n"
    expected_output += @hbt.overall_stat_description + "\n"
    assert_output expected_output do
      @command.list_all(Hbtrack::HabitPrinter.new)
    end
  end

  def test_execute
    expected_output = Hbtrack::Util.title Date.today.strftime('%B %Y').to_s
    expected_output += '1. ' +
                       @hbt.hp.print_latest_progress(@hbt.habits[0]) + "\n"
    expected_output += '2. ' +
                       @hbt.hp.print_latest_progress(@hbt.habits[1], 3) + "\n\n"
    expected_output += @hbt.overall_stat_description + "\n"
    assert_output expected_output do @command.execute end
  end

end
