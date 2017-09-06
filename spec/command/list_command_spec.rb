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

      expected = @command.list(
        'workout',
        Hbtrack::HabitPrinter.new(Hbtrack::CompletionRateSF.new)
      )

      expect(result).to eq expected
    end

    it 'should call #list_all when -a is given' do
      result = @command.execute

      expected = @command.list_all(Hbtrack::HabitPrinter.new)

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

      result = @command.list('workout', Hbtrack::HabitPrinter.new)

      expected = Hbtrack::Util.title 'workout'
      expected +=
        @command.printer.print_all_progress(habit) + "\n\n"
      expected += habit.overall_stat_description(Hbtrack::CompleteSF.new)

      expect(result).to eq expected
    end

    it 'should return error message if habit not found' do
      name = 'apple'
      result = @command.list(name, Hbtrack::HabitPrinter.new)

      expected = Hbtrack::ErrorHandler.raise_habit_not_found(name)

      expect(result).to eq expected
    end
  end

  it '#list_all should return the right output' do
    result = @command.list_all(Hbtrack::HabitPrinter.new)

    expected = Hbtrack::Util.title Date.today.strftime('%B %Y').to_s
    expected += '1. ' +
                @command.printer.print_latest_progress(@hbt.habits[0]) + "\n"
    expected += '2. ' +
                @command.printer.print_latest_progress(@hbt.habits[1], 3) + "\n\n"
    expected += @hbt.overall_stat_description

    expect(result).to eq expected
  end
end
