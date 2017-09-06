# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hbtrack::UpdateCommand do
  before do
    @hbt = Hbtrack::HabitTracker.new(
      Hbtrack::TEST_FILE,
      Hbtrack::OUTPUT_FILE
    )
    @command = Hbtrack::UpdateCommand.new(@hbt, ['workout'], true)
  end

  context '#execute' do
    before do
      @name = 'workout'
      @habit = @hbt.find(@name)
    end

    it 'should mark habit as done' do
      count = @habit.latest_stat[:done]

      result = @command.execute
      result_count = @habit.latest_stat[:done]

      expected = Hbtrack::Util.green('Done workout!')
      expected_count = count + 1

      expect(result).to eq expected
      expect(result_count).to eq expected_count
    end

    it 'should mark task as undone' do
      @command = Hbtrack::UpdateCommand.new(@hbt, [@name], false)
      @habit.progress[@habit.latest_key] = '111111' # Mock Undone Task
      count = @habit.latest_stat[:undone]

      result = @command.execute
      result_count = @habit.latest_stat[:undone]

      expected = Hbtrack::Util.green('Undone workout!')
      expected_count = count + 1

      expect(result).to eq expected
      expect(result_count).to eq expected_count
    end

    it 'should return error messages if habit_name doesnt exist' do
      name = 'ukulele'
      @command = Hbtrack::UpdateCommand.new(@hbt, [name], false)

      result = @command.execute

      expected = Hbtrack::ErrorHandler.raise_if_habit_error(name)

      expect(result).to eq expected
    end

    it 'should mark task as done for yesterday' do
      @command = Hbtrack::UpdateCommand.new(@hbt, ['workout', '-y'], true)
      @habit.progress[@habit.latest_key] = '0' * (Date.today.day - 1)
      count = @habit.latest_stat[:done]

      result = @command.execute
      result_count = @habit.latest_stat[:done]
      result_progress = @habit.progress[@habit.latest_key]

      expected = Hbtrack::Util.green('Done workout!')
      expected_count = count + 1
      expected_progress = '0' * (Date.today.day - 2) + '1'

      expect(result).to eq expected
      expect(result_count).to eq expected_count
      expect(result_progress).to eq expected_progress
    end
  end
end
