# frozen_string_literal: true

# A class that contains the helper methods
# used for CLI.
module Hbtrack
  class CLI
    FONT_COLOR = {
      green: "\e[32m",
      red: "\e[31m",
      blue: "\e[34m"
    }.freeze

    class << self
      # Define CLI.green, CLI.red, CLI.blue
      # which colorize string output in terminal
      FONT_COLOR.each do |key, value|
        define_method(key) do |string|
          value + string + "\e[0m"
        end
      end
    end

  end
end


