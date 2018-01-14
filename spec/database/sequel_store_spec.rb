# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hbtrack::Database::SequelStore do

  # TODO: Should refactor out
  Habit = Struct.new(:title, :display_order)
  Entry = Struct.new(:timestamp, :type)

  let(:store) { Hbtrack::Database::SequelStore.new(name: 'test.db') }

  after :each do
    File.delete('test.db')
  end

  describe 'habits' do
    before do
      struct = Habit.new("workout", 1)
      struct2 = Habit.new("read", 2)
      store.add_habit(struct)
      store.add_habit(struct2)
    end

    it 'should be able to get all habits' do
      habits = store.get_all_habits
      expect(habits.count).to eq 2
    end

    it 'should be able to get habits count' do
      count = store.get_habits_count
      expect(count).to eq 2
    end

    it 'should be able to get habit id from title' do
      id = store.get_habit_id_for('workout')
      expect(id).to eq 1
    end
  end

  describe 'entries' do
    let(:habit) do
      struct = Habit.new("workout", 1)
      store.add_habit(struct)
      store.get_habit(1)
    end

    before do
      struct = Entry.new('2017-02-25T12:24:16+08:00', 'missed')
      struct1 = Entry.new('2017-02-26T12:24:16+08:00', 'partially_completed')
      id = habit[:id]
      store.add_entry_of(id, struct)
      store.add_entry_of(id, struct1)
    end

    it 'should be able to get entries of a habit' do
      entries = store.get_entries_of_month(habit[:id], 2, 2017)

      expect(entries.count).to eq 2
      expect(entries[0][:type]).to eq 'missed'
      expect(entries[1][:type]).to eq 'partially_completed'
    end
  end

end
