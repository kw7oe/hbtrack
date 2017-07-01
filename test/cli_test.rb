# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require 'Date'
require_relative '../lib/cli'

class TestCLI < MiniTest::Test
  def setup
    @cli = CLI.new('test_data')
  end

  def test_cli_list
    assert_output "1. workout\n2. read\n" do
      @cli.parse_arguments(['list'])
    end
  end

  def test_cli_add
    @cli.parse_arguments(%w[add learning])
    assert_equal 'learning', @cli.habits.last.name
  end

  def test_cli_done
    @cli.parse_arguments(%w[done learning])
    assert_equal 1, @cli.habits.last.progress.length
  end
end
