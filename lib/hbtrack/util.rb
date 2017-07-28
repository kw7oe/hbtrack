# frozen_string_literal: true

module Hbtrack
  # This class contains the methods that 
  # are used to format the progress of a Habit
  # into string
  class Util

    class << self

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
        year = key.to_s.split(",")[0]
        ' ' * no_of_space + get_month_from(key) + 
        " #{year}" + " : "
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

