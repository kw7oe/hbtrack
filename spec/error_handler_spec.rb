# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hbtrack::ErrorHandler do
  it 'should print invalid habit' do
    result = Hbtrack::ErrorHandler.raise_habit_not_found('workout')

    expected = Hbtrack::Util.red('Invalid habit: workout not found.')

    expect(result).to eq expected
  end

  it 'should print invalid arguments' do
    result = Hbtrack::ErrorHandler.raise_invalid_arguments

    expected = Hbtrack::Util.red('Invalid argument: habit_name is expected.')

    expect(result).to eq expected
  end

  it 'should print habit_name too long' do
    result = Hbtrack::ErrorHandler.raise_habit_name_too_long

    expected = Hbtrack::Util.red('habit_name too long.')

    expect(result).to eq expected
  end

  it '#raise_if_habit_error should print invalid argument if habit_name is nil' do
    result = Hbtrack::ErrorHandler.raise_if_habit_error(nil)

    expected = Hbtrack::Util.red('Invalid argument: habit_name is expected.')

    expect(result).to eq expected
  end

  it '#raise_if_habit_error should print habit not found if habit_name is present' do
    result = Hbtrack::ErrorHandler.raise_if_habit_error('workout')

    expected = Hbtrack::Util.red('Invalid habit: workout not found.')

    expect(result).to eq expected
  end
end
