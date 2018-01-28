# frozen_string_literal: true

require 'spec_helper'
require 'hbtrack/util'
require 'hbtrack/error_handler'

RSpec.describe Hbtrack::UpdateCommand do
  let(:store) { Hbtrack::Database::SequelStore.new(name: 'test.db') }
  let(:done_command) { Hbtrack::UpdateCommand.new(nil, nil, true) }

  before do
    habit1 = Habit.new('workout', 1)
    habit2 = Habit.new('read', 2)
    store.add_habit(habit1)
    store.add_habit(habit2)
  end

  after do
    File.delete('test.db')
  end

  describe '#update_all_in_db' do
    it 'should add completed entry to all habits to database' do
      result = done_command.update_all_in_db(store, Date.today, true)

      entries1 = store.get_entries_of(1).all
      entries2 = store.get_entries_of(2).all

      expect(entries1.count).to eq 1
      expect(entries2.count).to eq 1

      expect(entries1[0][:type]).to eq 'completed'
      expect(entries2[0][:type]).to eq 'completed'
      expect(result).to eq Hbtrack::Util.green("Update successfully!")
    end

    it 'should add missed entry to all habits to database' do
      result = done_command.update_all_in_db(store, Date.today, false)

      entries1 = store.get_entries_of(1).first
      entries2 = store.get_entries_of(2).first

      expect(entries1[:type]).to eq 'missed'
      expect(entries2[:type]).to eq 'missed'
      expect(result).to eq Hbtrack::Util.green("Update successfully!")
    end
  end

  describe '#update_in_db' do
    it 'should add done entry to database' do
      result = done_command.update_in_db(store, 'workout', Date.today, true)

      entries = store.get_entries_of(1).all
      count = entries.count

      expect(count).to eq 1
      expect(entries[0][:type]).to eq "completed"
      expect(result).to eq Hbtrack::Util.green("Update successfully!")
    end

    it 'should raise error if habit not found' do
      result = done_command.update_in_db(store, 'not habit', Date.today, true)
      expected = Hbtrack::ErrorHandler.raise_habit_not_found('not habit')
      expect(result).to eq expected
    end

    it 'should not add multiple entry  per day for a habit to database' do
      done_command.update_in_db(store, 'workout', Date.today, true)
      done_command.update_in_db(store, 'workout', Date.today, true)

      count = store.get_entries_count_of(1)

      expect(count).to eq 1
    end

    it 'should update entry if the entry exists' do
      done_command.update_in_db(store, 'workout', Date.today, true)
      done_command.update_in_db(store, 'workout', Date.today, false)

      count = store.get_entries_count_of(1)
      entry = store.get_latest_entry_of(1)

      expect(count).to eq 1
      expect(entry[:type]).to eq 'missed'
    end
  end
end
