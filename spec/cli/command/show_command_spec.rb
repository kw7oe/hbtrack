# frozen_string_literal: true

require 'spec_helper'
require 'hbtrack/cli/view'

RSpec.describe Hbtrack::ShowCommand do
  let(:store) { Hbtrack::Database::SequelStore.new(name: 'test.db') }
  let(:show_command) { Hbtrack::ShowCommand.new(nil, nil) }

  before do
    habit1 = Habit.new('workout', 1)
    entry1 = Entry.new('2017-01-01T12:24:16+08:00', 'missed')
    entry2 = Entry.new('2017-01-02T12:24:16+08:00', 'partially_completed')
    store.add_habit(habit1)
    store.add_entry_of(1, entry1)
    store.add_entry_of(1, entry2)
  end

  after do
    File.delete('test.db')
  end

  describe '#execute' do
    it 'should call #show' do
      show_command = Hbtrack::ShowCommand.new('test.db', 'workout')
      result = show_command.execute
      expected = show_command.show(store, 'workout')
      p expected

      expect(result).to eq expected
    end
  end

  describe '#show' do
    it 'should show habit correctly' do
      result = show_command.show(store, 'workout')
      habit = store.get_habit_by_title('workout')
      entries = show_command.get_entries_from_db(store, habit)

      expected = View.show_habit(habit, entries)

      expect(result).to eq expected
    end

    it 'should show no habit error if habit not found' do
      result = show_command.show(store, 'read')
      expected = Hbtrack::ErrorHandler.raise_habit_not_found('read')

      expect(result).to eq expected
    end
  end

  describe '#get_entries_from_db' do
    it 'should get all entries of a habit' do
      habit, = store.get_habit_by_title('workout')
      entries = show_command.get_entries_from_db(store, habit)

      expect(entries['2017-01'][0][:type]).to eq 'missed'
    end
  end
end
