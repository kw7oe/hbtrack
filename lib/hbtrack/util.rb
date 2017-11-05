# frozen_string_literal: true

module Hbtrack
  # This class contains the methods that
  # are used to format the progress of a Habit
  # into string
  class Util
    FONT_COLOR = {
      green: "\e[32m",
      red: "\e[31m",
      blue: "\e[34m"
    }.freeze

    class << self
      # Define Util.green, Util.red, Util.blue
      # which colorize string output in terminal
      FONT_COLOR.each do |key, value|
        define_method(key) do |string|
          value + string + "\e[0m"
        end
      end
      
      # Format the string with title style.
      #
      # @param string [String] the string to be styled as title
      # @return [Nil]
      #
      # == Example
      #
      #   puts Util.title("Title")
      #   # Title
      #   # -----
      #   #=> nil
      def title(string)
        string + "\n" +
          '-' * string.length + "\n"
      end

      # Convert key into date in string form.
      #
      # @param key [Symbol] The key of the progress in the
      #   form of :'year, month'. Example: :"2017,7"
      # @param no_of_space [Numeric] number of space to be
      #   added in front
      # @return [String] a string in date form.
      #
      # == Example
      #
      #   Util.convert_key_to_date(:"2017,7", 0)
      #   #=> "July 2016 : "
      def convert_key_to_date(key, no_of_space)
        year = key.to_s.split(',')[0]
        ' ' * no_of_space + get_month_from(key) +
          " #{year}" + ' : '
      end

      # TODO: Test needed
      def get_date_from(key: )
        date_component = key.to_s.split(',').map(&:to_i)
        Date.new(date_component[0], date_component[1], 1)
      end

      # Get the month in string form from given key
      #
      # @param key [Symbol] The key of the progress
      # @return [String] month
      #
      # == Example
      #
      #   Util.get_month_from(:"2017,7")
      #   #=> "July"
      def get_month_from(key)
        key = key.to_s.split(',')
        Date::MONTHNAMES[key[1].to_i]
      end
    end
  end
end
