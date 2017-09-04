# frozen_string_literal: true

require 'test_helper'

class TestUtil < MiniTest::Test
  def setup
    @util = Hbtrack::Util
  end

  def test_convert_progress_key_to_date
    expected_result = 'June 2017 : '
    assert_equal expected_result, @util.convert_key_to_date(:"2017,6", 0)
  end

  def test_get_month_from
    assert_equal 'January', @util.get_month_from(:"2017,1")
  end
end
