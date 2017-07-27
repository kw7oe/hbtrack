# frozen_string_literal: true

module Hbtrack
  # This class contains the methods that 
  # are used to format the progress of a Habit
  # into string
  class Util

    class << self
      def convert_key_to_date(key, no_of_space)
        year = key.to_s.split(",")[0]
        ' ' * no_of_space + get_month_from(key) + 
        " #{year}" + " : "
      end

      def get_month_from(key)
        key = key.to_s.split(',')
        Date::MONTHNAMES[key[1].to_i]
      end
    end
  end
end

