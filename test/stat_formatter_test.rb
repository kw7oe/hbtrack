# frozen_string_literal: true

require 'test_helper'

class TestStatFormatter < MiniTest::Test
  def setup
    @value = { done: 5, undone: 11 }
    @util = Hbtrack::Util
  end

  def test_format_done_and_undone_only
    expected_result = @util.green('Done: 5') + "\n" +
                      @util.red('Undone: 11')
    assert_equal expected_result, Hbtrack::DoneUndoneSF.new.format(@value)
  end

  def test_format_complete
    expected_result = 'All: 16, Done: 5, Undone: 11'
    assert_equal expected_result, Hbtrack::CompleteSF.new.format(@value)
  end

  def test_to_percentage
    expected_result = { done: 31.25, undone: 68.75 }
    assert_equal expected_result,
                 Hbtrack::CompletionRateSF.new.to_percentage(@value)
  end

  def test_completion_rate
    expected_result = 'Completion rate: 31.25%'
    assert_equal expected_result,
                 Hbtrack::CompletionRateSF.new.format(@value)
  end
end
