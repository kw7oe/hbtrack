class Habit
  attr_accessor :id, :name, :progress
  def initialize(name, progress = [])
    @name = name
    @progress = progress
  end

  def to_s
    "#{name}"
  end
end
