# frozen_string_literal: true

require "test_helper"

class TestHabitPrinter < MiniTest::Test

  def setup
    string = <<~EOF
      workout
      2017,5: 0000000000011111
      2017,6: 0000000000011111
    EOF
    @latest_key = Hbtrack::Habit.get_progress_key_from(Date.today)
    string += @latest_key.to_s + ": 1"
    @habit = Hbtrack::Habit.initialize_from_string(string)
    @hp = Hbtrack::HabitPrinter.new(
      Hbtrack::CompleteSF.new
    )
    @cli = Hbtrack::CLI
  end

  def test_pretty_print_latest
    expected_result = 'workout : ' + @cli.green('*') +
                      ' ' * 31 +
                      "All: 1, Done: 1, Undone: 0"
    assert_equal expected_result,
                 @hp.print_latest_progress(@habit)
  end

  def test_pretty_print_all
    stat = ' ' * 16 +
           'All: 16, Done: 5, Undone: 11'
    progress = @cli.red('*') * 11 + Hbtrack::CLI.green('*') * 5
    expected_result = Hbtrack::Util.convert_key_to_date(:"2017,5", @hp.calculate_space_needed_for(@habit, :"2017,5")) + 
                      progress + stat + "\n" +
                      Hbtrack::Util.convert_key_to_date(:"2017,6", @hp.calculate_space_needed_for(@habit, :"2017,6")) + 
                      progress + stat + "\n" +
                      Hbtrack::Util.convert_key_to_date(@latest_key, @hp.calculate_space_needed_for(@habit, @latest_key)) + 
                      @cli.green('*') +
                      ' ' * 31 +
                      'All: 1, Done: 1, Undone: 0'
    assert_equal expected_result,
                 @hp.print_all_progress(@habit)
  end

end
