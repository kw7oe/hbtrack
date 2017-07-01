# frozen_string_literal: true

require_relative 'lib/cli'

# CLI for the application
module Hb
  def self.run(args)
    cli = CLI.new("test_data")
    cli.parse_arguments(args)
  end
end

Hb.run(ARGV)
