# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hbtrack::ListCommand do
  before do
    @hbt = Hbtrack::HabitTracker.new(
      Hbtrack::TEST_FILE,
      Hbtrack::OUTPUT_FILE
    )
    @hbt.habits.each(&:done)
    @command = Hbtrack::ListCommand.new(@hbt, ['-a'])
  end

  context '#execute' do
    it 'shoud call #list when habit name is given' do
      @command = Hbtrack::ListCommand.new(@hbt, ['workout', '-p'])
      result = @command.execute
      expected = @command.list( 'workout')
      expect(result).to eq expected
    end

    it 'should call #list_all when -a is given' do
      result = @command.execute
      expected = @command.list_all(@command.month)
      expect(result).to eq expected
    end

    it 'should all #list_all with date when -a -d is given' do
      @command = Hbtrack::ListCommand.new(@hbt, ['-a', '--month', '2017,6'])
      result = @command.execute
      expected = @command.list_all(:'2017,6')
      expect(result).to eq expected
    end

    it 'should call #help when no arguments given' do
      @command = Hbtrack::ListCommand.new(@hbt, [])
      result = @command.execute
      expected = @command.help
      expect(result).to eq expected
    end
  end

  context '#list' do
    it 'should have the right output' do
      habit = @hbt.find('workout')
      result = @command.list('workout')
      expected = Hbtrack::Util.title 'workout'
      expected +=
        @command.printer.print_all_progress(habit) + "\n\n"
      expected += habit.overall_stat_description(Hbtrack::CompleteSF.new)
      expect(result).to eq expected
    end

    it 'should return error message if habit not found' do
      name = 'apple'
      result = @command.list(name)
      expected = Hbtrack::ErrorHandler.raise_habit_not_found(name)
      expect(result).to eq expected
    end
  end

  context '#list_all' do
    it 'should return the right output' do
      @command = Hbtrack::ListCommand.new(@hbt, ['-a', '--month', '2017,6'])
      key = @command.month
      date = Hbtrack::Util.get_date_from(key: key)
      result = @command.list_all(key)

      expected = Hbtrack::Util.title date.strftime('%B %Y').to_s
      expected += '1. ' +
                  @command.printer.print_progress_for(habit: @hbt.habits[0], key: key) + "\n"
      expected += '2. ' +
                  @command.printer.print_progress_for(habit: @hbt.habits[1], key: key, no_of_space: 3) + "\n\n"
      expected += @hbt.overall_stat_description_for(key:key, formatter:  @command.formatter)

      expect(result).to eq expected
    end

    it 'should return error message if key provided invalid' do
      result = @command.list_all(:'2015,9')
      expected = Hbtrack::Util.red 'Invalid month provided.'
      expect(result).to eq expected
    end

    it 'should return no habits added' do
      @hbt.habits = []
      result = @command.list_all(@command.month)
      expected = Hbtrack::Util.blue 'No habits added yet.'
      expect(result).to eq expected
    end
  end
end
