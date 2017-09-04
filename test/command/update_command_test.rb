# frozen_string_literal: true

require 'test_helper'

class TestUpdateCommand < MiniTest::Test
  def setup
    @hbt = Hbtrack::HabitTracker.new(
      Hbtrack::TEST_FILE,
      Hbtrack::OUTPUT_FILE
    )
    @command = Hbtrack::UpdateCommand.new(@hbt, ['workout'], true)
  end

  def test_update
    expected_output = Hbtrack::Util.green('Done workout!')
    assert_equal expected_output, @command.execute
  end

  def test_done_blank
    skip
    expected_output = Hbtrack::Util.red('Invalid argument: ' \
                      'habit_name is expected.')
    assert_equal expected_output, @command.execute
  end

  def test_done_yesterday
    @command = Hbtrack::UpdateCommand.new(@hbt, ['workout', '-y'], true)
    expected_output = Hbtrack::Util.green('Done workout!')
    assert_equal expected_output, @command.execute
  end

  def test_undone
    @command = Hbtrack::UpdateCommand.new(@hbt, ['workout'], false)
    expected_output = Hbtrack::Util.green('Undone workout!')
    assert_equal expected_output, @command.execute
  end

  def test_undone_yesterday
    @command = Hbtrack::UpdateCommand.new(@hbt, ['workout', '-y'], false)
    expected_output = Hbtrack::Util.green('Undone workout!')
    assert_equal expected_output, @command.execute
  end
end
