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
    @done_count = @habit_tracker.habits.count
    @undone_count = (Date.today.day - 1) * 2
    @total = @done_count + @undone_count
  end

  it "#longest_name should return the longest_name" do
    expect(@habit_tracker.longest_name).to eq 'workout'
  end

  it "#total_habits_stat should return the right stat" do
    result = { done: @done_count, undone: @undone_count }
    expect(@habit_tracker.total_habits_stat).to eq result
  end

  it "#overall_stat_description should return the right string" do
    result = Hbtrack::Util.title 'Total'
    result += "All: #{@total}, Done: #{@done_count}, Undone: #{@undone_count}"
    expect(@habit_tracker.overall_stat_description).to eq result
  end

  it "#find should return the right habit" do
    result = 'workout'
    expect(@habit_tracker.find('workout').name).to eq result
  end

  it "#find_or_create should return the habit if it exists" do
    count = @habit_tracker.habits.count
    result = 'read'
    expect(@habit_tracker.find_or_create('read').name).to eq result
    expect(@habit_tracker.habits.count).to eq (count)
  end

  it "#find_or_create should create the habit if it doesn't exists" do
    count = @habit_tracker.habits.count
    result = 'ukulele'
    expect(@habit_tracker.find_or_create('ukulele').name).to eq result
    expect(@habit_tracker.habits.count).to eq (count + 1)
  end
end
