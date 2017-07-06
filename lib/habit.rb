# frozen_string_literal: true

require 'date'
require_relative 'cli'

# Habit provide a rich library to track the
# progress of your habit.
class Habit
  attr_accessor :name
  attr_reader :progress

  def initialize(name, progress = {})
    @name = name
    @progress = progress
  end

  def name_length
    name.length
  end

  def done(date = Date.today)
    add_done(date)
  end

  def progress_output
    arr = @progress.map do |key, value|
      "#{key}:#{value}\n"
    end
    arr.join('')
  end

  def pretty_print(no_of_space = 0)
    "#{name}" + " " * no_of_space + " : " +
    pretty_print_progress(@progress.values.last) 
  end

  def pretty_print_progress(progress_value)
    stat = progress_value.lstrip.split("").map do |x| 
      x == "0" ? CLI.red("*") : CLI.green("*")
    end.join("")
    return stat
  end

  def to_s
    "#{name}\n" + progress_output + "\n"
  end

  class << self
    # Generate hash key for progress based
    # on date.
    #
    # Example
    #
    #   Habit.get_progress_key_from(Date.new(2017, 7, 18))
    #   # => :"2017,6"
    def get_progress_key_from(date)
      date.strftime('%Y,%-m').to_sym
    end

    # Initialize Habit object from string.
    #
    # string - The string to be parse.
    #
    # Example
    #
    #   Habit.initialize_from_string("workout\n2017,6:1001")
    #   # => #<Habit:0x007f9be6041b70 @name="workout", @progress={:"2017,6"=>"1001"}>
    def initialize_from_string(string)
      arr = string.split("\n")
      habit_name = arr.shift
      hash = {}
      arr.each do |s|
        a = s.split(':')
        hash[a[0].to_sym] = a[1]
      end
      Habit.new(habit_name, hash)
    end
  end

  private

  def add_done(date)
    key = Habit.get_progress_key_from(date)
    @progress[key] = ' ' unless @progress.key? key
    i = date.day - @progress[key].length
    @progress[key] += '0' * i
    @progress[key] += '1'
  end
end
