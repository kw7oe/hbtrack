# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require 'Date'
require_relative '../lib/cli'

class TestCLI < MiniTest::Test
  def setup
    @cli = CLI.new("test_file")
    @cli.parse_arguments(%w[add workout])
  end

  def test_cli_list
    assert_output "1. workout\n" do
      @cli.parse_arguments(['list'])
    end
  end

  def test_cli_add
    assert_equal 'workout', @cli.habits.first.name
  end
end
