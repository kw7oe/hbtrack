# frozen_string_literal: true

module Hbtrack
  class ErrorHandler
    class << self
      def raise_error_msg(msg)
        return Util.red msg
      end

      def raise_if_habit_error(habit_name)
        return raise_invalid_arguments if habit_name.nil?
        raise_habit_not_found(habit_name)
      end

      def raise_habit_not_found(habit_name)
        raise_error_msg "Invalid habit: #{habit_name} not found."
      end

      def raise_invalid_arguments
        raise_error_msg 'Invalid argument: habit_name is expected.'
      end

      def raise_habit_name_too_long
        raise_error_msg 'habit_name too long.'
      end
    end
  end
end
