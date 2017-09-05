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
    result = Hbtrack::Util.blue('Remove workout!')
    expect(result).to eq @command.remove('workout')
    expect(1).to eq @hbt.habits.count
  end

end

