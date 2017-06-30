require_relative "progress"

class Habit
  attr_accessor :name
  attr_reader :progress

  def initialize(name, progress = {})
    @name = name
    @progress = progress
  end

  def done(date)
    add_done(date) 
  end
   
  def to_s
    "#{name}"
  end

  private 
  def add_done(date)
    key = date.strftime("%Y,%-m").to_sym
    @progress[key] = "" unless @progress.key? key

    i = date.day - @progress[key].length - 1
    @progress[key] += "0" * i
    @progress[key] += "1"
  end
      
end
