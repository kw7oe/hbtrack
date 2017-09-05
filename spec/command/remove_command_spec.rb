require "spec_helper"

RSpec.describe Hbtrack::RemoveCommand do 

  before do 
    @hbt = Hbtrack::HabitTracker.new(
      Hbtrack::TEST_FILE,
      Hbtrack::OUTPUT_FILE
    )
    @command = Hbtrack::RemoveCommand.new(@hbt, ['workout'])
  end

  it "should remove habit" do 
    count = @hbt.habits.count
    result = Hbtrack::Util.blue('Remove workout!')
    expect(@command.execute).to eq result
    expect(@hbt.habits.count).to eq (count - 1)
  end

end

