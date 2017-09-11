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
      @habit.progress[@habit.latest_key] = '1' * (Date.today.day - 1) # Mock Undone Task
      count = @habit.latest_stat[:undone]

      result = @command.execute
      result_count = @habit.latest_stat[:undone]

      expected = Hbtrack::Util.green('Undone workout!')
      expected_count = count + 1

      expect(result).to eq expected
      expect(result_count).to eq expected_count
    end

    it 'should mar multiple tasks as done' do 
      habit1 = @hbt.find('workout')
      habit2 = @hbt.find('read')
      @command = Hbtrack::UpdateCommand.new(@hbt, ['workout', 'read'], true)

      count1 = habit1.latest_stat[:done]
      count2 = habit2.latest_stat[:done]

      result = @command.execute
      result_count1 = habit1.latest_stat[:done]
      result_count2 = habit2.latest_stat[:done]

      expected = Hbtrack::Util.green('Done workout,read!')
      expected_count1 = count1 + 1
      expected_count2 = count2 + 1

      expect(result).to eq expected
      expect(result_count1).to eq expected_count1
      expect(result_count2).to eq expected_count2
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

  context '#update_all' do
    it 'should mark all habits as done' do
      count = @hbt.habits.reduce(0) { |a, x| a + x.latest_stat[:done] }

      result = @command.update_all(Date.today, true)
      result_count = @hbt.habits.reduce(0) { |a, x| a + x.latest_stat[:done] }

      expected = Hbtrack::Util.green('Done all habits!')
      expected_count = count + @hbt.habits.length

      expect(result).to eq expected
      expect(result_count).to eq expected_count
    end
  end

  context '#update_remaining' do
    before do
      @hbt.find_or_create('workout').done
      @hbt.find_or_create('read')
      @hbt.find_or_create('ukulele')
      @command = Hbtrack::UpdateCommand.new(@hbt, ['-r'], true)
    end

    it 'should mark remaining habits as done' do
      count = @hbt.done_count_for(date: Date.today)

      result = @command.update_remaining(Date.today, true)
      result_count = @hbt.done_count_for(date: Date.today)

      expected = Hbtrack::Util.green('Done remaining habit(s)!')
      expected_count = count + 2

      expect(result).to eq expected
      expect(result_count).to eq expected_count
    end

    it 'should mark remaining habits as undone' do
      count = @hbt.undone_count_for(date: Date.today)

      result = @command.update_remaining(Date.today, false)
      result_count = @hbt.undone_count_for(date: Date.today)

      expected = Hbtrack::Util.green('Undone remaining habit(s)!')
      expected_count = count + 2

      expect(result).to eq expected
      expect(result_count).to eq expected_count
    end
  end
end
