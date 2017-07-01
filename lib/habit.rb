# frozen_string_literal: true

require 'date'

# Habit provide a rich library to track the
# progress of your habit.
class Habit
  attr_accessor :name
  attr_reader :progress

  def initialize(name, progress = {})
    @name = name
    @progress = progress
  end

  def done(date = Date.today)
    add_done(date)
  end

  def progress_output
    @progress.map { |key, value| "#{key}: #{value}\n" }.join('')
  end

  def to_s
    "#{name}\n" + progress_output
  end

  # Class Methods
  class << self 
    def get_progress_key_from(date)
      date.strftime('%Y,%-m').to_sym
    end

    def initialize_from_string(string)
      arr = string.split("\n")
      habit_name = arr.shift
      progress = arr.map do |s| 
        a = s.split(":") 
        key = a[0].to_sym
        value = a[1]
        { key => value }
      end
      Habit.new(habit_name, progress)
    end
  end

  private

  def add_done(date)
    key = Habit.get_progress_key_from(date)
    @progress[key] = '' unless @progress.key? key
    i = date.day - @progress[key].length - 1
    @progress[key] += '0' * i
    @progress[key] += '1'
  end
end
