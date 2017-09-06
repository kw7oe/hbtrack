# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hbtrack::AddCommand do
  before do
    @hbt = Hbtrack::HabitTracker.new(
      Hbtrack::TEST_FILE,
      Hbtrack::OUTPUT_FILE
    )
    @command = Hbtrack::AddCommand.new(@hbt, ['sleeping'])
  end

  it 'should add habit' do
    count = @hbt.habits.count
    result = Hbtrack::Util.green('Add sleeping!')
    expect(@command.execute).to eq result
    expect(@hbt.habits.count).to eq(count + 1)
  end
end
