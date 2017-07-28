# frozen_string_literal: true

require "test_helper"

class TestStatFormatter < MiniTest::Test

  def setup
    @value = { done: 5, undone: 11 }
    @cli = Hbtrack::CLI
    @sf = Hbtrack::StatFormatter
  end

  def test_format_done_and_undone_only
    expected_result = @cli.green("Done: 5") + "\n" +
                      @cli.red("Undone: 11")
    assert_equal expected_result, @sf.done_undone(@value)
  end

  def test_format_complete
    expected_result = '(All: 16, Done: 5, Undone: 11)'
    assert_equal expected_result, @sf.complete(@value)
  end

  def test_to_percentage
    expected_result = { done: 31.25, undone: 68.75 }
    assert_equal expected_result, @sf.to_percentage(@value)
  end

  def test_completion_rate
    expected_result = "Completion rate: 31.25%"
    assert_equal expected_result, @sf.completion_rate(@value)
  end

end
