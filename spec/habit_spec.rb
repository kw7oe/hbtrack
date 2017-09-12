# frozen_string_literal: true

require 'spec_helper'
require 'date'

RSpec.describe Hbtrack::Habit do

  before do 
    @habit = Hbtrack::Habit.new('Workout')
  end

  def initialize_habit_from_string
    string = <<~EOF
      workout
      2017,5: 0000000000011111
      2017,6: 0000000000011111
      2017,7: 1
    EOF
    @habit = Hbtrack::Habit.initialize_from_string(string)
  end

  context "#initialize_from_string" do
    it 'should initialize habit' do
      initialize_habit_from_string

      expect(@habit).not_to be_nil
      expect(@habit.progress.length).to eq 3
    end
  end

  context "#name" do
    it 'should return the right name' do
      expect(@habit.name).to eq 'Workout'
    end

    it 'should have the right length' do
      expect(@habit.name_length).to eq 7
    end
  end

  context "#latest_progrss" do
    it 'should return the right progress' do
      @habit.done

      expected = ' ' * (Date.today.day - 1) + '1'

      expect(@habit.latest_progress).to eq expected
    end

  end

  context '#done' do
    it 'should mark task as done with latest progress' do
      date = Date.new(2017, 6, 17)
      key = Hbtrack::Habit.get_progress_key_from(date)

      @habit = Hbtrack::Habit.new('Workout', key => '0010')
      @habit.done(true, date)

      expected = '0010            1'

      expect(@habit.progress[key]).to eq expected
    end

    it 'should handle done twice on the same day' do
      date = Date.new(2017, 7, 4)
      key = Hbtrack::Habit.get_progress_key_from(date)

      @habit = Hbtrack::Habit.new('Workout', key => '00')
      @habit.done(true, date)

      expect(@habit.progress[key]).to eq '00 ' + '1'

      @habit.done(true, date)

      expect(@habit.progress[key]).to eq '00 ' + '1'
    end

    it 'should mark task as undone with latest progress' do
      @habit.done(false)

      expected = ' ' * (Date.today.day - 1) + '0'

      expect(@habit.latest_progress).to eq expected
    end

    it 'should handle done and undone correctly' do
      @habit.done(false)

      expected = ' ' * (Date.today.day - 1) + '0'

      expect(@habit.latest_progress).to eq expected

      @habit.done(true)

      expected = ' ' * (Date.today.day - 1) + '1'
      expect(@habit.latest_progress).to eq expected
    end
  end

  context '#progress_output' do
    it 'should return the right output' do
      @habit.done

      key = Hbtrack::Habit.get_progress_key_from(Date.today)

      expected = "#{key}: #{@habit.progress[key]}\n"

      expect(@habit.progress_output).to eq expected
    end

    it 'should return multiple progress output correctly' do
      key1 = Hbtrack::Habit.get_progress_key_from(
        Date.new(2017, 4, 9)
      )
      key2 = Hbtrack::Habit.get_progress_key_from(
        Date.new(2017, 5, 10)
      )

      @habit = Hbtrack::Habit.new('Workout',
                                  key1 => '00010',
                                  key2 => '11101')
      expected = <<~EOF
       2017,4: 00010
       2017,5: 11101
      EOF
      expect(@habit.progress_output).to eq expected
    end
  end

  context '#to_s' do
    it 'should return the right output' do
      expected = "Workout\n#{@habit.progress_output}\n"

      expect(@habit.to_s).to eq expected
    end
  end
end




# def test_intialize_from_string_equal_to_s
#   string = <<~EOF
#     workout
#     2017,5: 0000000000011111
#     2017,6: 0000000000011111
#     2017,7: 1

#   EOF
#   assert_equal string, Hbtrack::Habit.initialize_from_string(string).to_s
# end

# def test_stat_for_progress
#   initialize_habit_from_string
#   expected_result = { done: 5, undone: 11 }
#   assert_equal expected_result, @habit.stat_for_progress('2017,5'.to_sym)
# end

# def test_overall_stat
#   initialize_habit_from_string
#   expected_result = { done: 11, undone: 22 }
#   assert_equal expected_result, @habit.overall_stat
# end

# def test_overall_stat_description
#   initialize_habit_from_string
#   expected_output = "Total\n-----\n"
#   expected_output += 'All: 33, Done: 11, '
#   expected_output += 'Undone: 22'
#   assert_equal expected_output, @habit.overall_stat_description(Hbtrack::CompleteSF.new)
# end
