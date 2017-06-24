class Habit
  attr_accessor :id, :name, :progress
  def initialize(id, name, progress = [])
    @id = id
    @name = name
    @progress = progress
  end
end
