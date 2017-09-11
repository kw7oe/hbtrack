# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hbtrack::RemoveCommand do
  before do
    @hbt = Hbtrack::HabitTracker.new(
      Hbtrack::TEST_FILE,
      Hbtrack::OUTPUT_FILE
    )
    @command = Hbtrack::RemoveCommand.new(@hbt, ['workout'])
  end

  context '#execute' do
    it 'should remove habit' do
      count = @hbt.habits.count
      result = Hbtrack::Util.blue('Remove workout!')
      expect(@command.execute).to eq result
      expect(@hbt.habits.count).to eq(count - 1)
    end

    it 'should raise habit not found' do
      name = 'apple'
      @command = Hbtrack::RemoveCommand.new(@hbt, [name])
      result = @command.execute

      expected = Hbtrack::ErrorHandler.raise_habit_not_found(name)

      expect(result).to eq expected
    end

    it 'should remove multiple habits' do
      @command = Hbtrack::RemoveCommand.new(@hbt, ['workout', 'read'])
      count = @hbt.habits.count

      result = Hbtrack::Util.blue('Remove workout,read!')

      expect(@command.execute).to eq result
      expect(@hbt.habits.count).to eq(count - 2)
    end
  end
end
