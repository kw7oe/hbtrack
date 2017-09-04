# frozen_string_literal: true

module Hbtrack
  class Store
    def initialize(habits, file_name)
      @habits = habits
      @file_name = file_name
    end

    def save
      File.open(@file_name, 'w') do |f|
        @habits.each do |habit|
          f.puts habit
        end
      end
    end
  end
end
