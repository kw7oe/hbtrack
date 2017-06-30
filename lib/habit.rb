require_relative "progress"
require "date"

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
    string = ""
    @progress.each do |key, value|
      string << "#{key}: #{value}\n"
    end
    string
  end
   
  def to_s
    return "#{name}\n" + progress_output
  end

  def self.get_progress_key_from(date)
    date.strftime("%Y,%-m").to_sym
  end

  private 
  def add_done(date)
    key = Habit.get_progress_key_from(date)
    @progress[key] = "" unless @progress.key? key
    i = date.day - @progress[key].length - 1
    @progress[key] += "0" * i
    @progress[key] += "1"
  end
      
end
