# frozen_string_literal: true

module Hbtrack
  module Database
    # Data Abstraction
    Habit = Struct.new(:title, :display_order)
    Entry = Struct.new(:timestamp, :type)
  end
end
