# frozen_string_literal: true

require 'spec_helper'
require 'date'

RSpec.describe Hbtrack::HabitTracker do
  before do
    @habit_tracker = Hbtrack::HabitTracker.new(
      Hbtrack::TEST_FILE,
      Hbtrack::OUTPUT_FILE
    )
    @habit_tracker.habits.each(&:done)
    @habit_count = @habit_tracker.habits.count
    @done_count = @habit_tracker.habits.count
    @undone_count = 0
    @total = @done_count + @undone_count
  end

  it '#longest_name should return the longest_name' do
    expect(@habit_tracker.longest_name).to eq 'workout'
  end

  it '#total_habits_stat should return the right stat' do
    result = { done: @done_count, undone: @undone_count }
    expect(@habit_tracker.total_habits_stat).to eq result
  end

  it '#overall_stat_description should return the right string' do
    result = Hbtrack::Util.title 'Total'
    result += "All: #{@total}, Done: #{@done_count}, Undone: #{@undone_count}"
    expect(@habit_tracker.overall_stat_description(Hbtrack::CompleteSF.new)).to eq result
  end

  it '#find should return the right habit' do
    result = 'workout'
    expect(@habit_tracker.find('workout').name).to eq result
  end

  it '#done_count_for should return the right done count' do
    expect(@habit_tracker.done_count_for(date: Date.today)).to eq @done_count
  end

  it '#done_count_for should return the right done count' do
    @habit_tracker.habits.each { |h| h.done(false) }
    expect(@habit_tracker.undone_count_for(date: Date.today)).to eq 2
  end

  context '#create' do
    it 'should create habit if habit_name valid' do
      @habit_tracker.create('ukulele')
      expect(@habit_tracker.habits.count).to eq(@habit_count + 1)
    end

    it 'should return error messages if habit name too long' do
      long_name = 'very_very_long_name'
      result = Hbtrack::ErrorHandler.raise_habit_name_too_long
      expect(@habit_tracker.create(long_name)).to eq result
    end

    it 'should return invalid arguments msg if habit_name absent' do
      result = Hbtrack::ErrorHandler.raise_invalid_arguments
      expect(@habit_tracker.create(nil)).to eq result
    end
  end

  context '#find_or_create' do
    it 'should return the habit if it exists' do
      result = 'read'
      expect(@habit_tracker.find_or_create('read').name).to eq result
      expect(@habit_tracker.habits.count).to eq @habit_count
    end

    it "should create the habit if it doesn't exists" do
      result = 'ukulele'
      expect(@habit_tracker.find_or_create('ukulele').name).to eq result
      expect(@habit_tracker.habits.count).to eq(@habit_count + 1)
    end
  end
end
