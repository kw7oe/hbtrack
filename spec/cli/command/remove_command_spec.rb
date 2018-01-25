# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hbtrack::RemoveCommand do
  let(:store) { Hbtrack::Database::SequelStore.new(name: 'test.db') }
  let(:remove_command) { Hbtrack::RemoveCommand.new(nil, nil) }

  before do
    habit1 = Habit.new('workout', 1)
    habit2 = Habit.new('read', 2)
    entry1 = Entry.new('2017-01-01T12:24:16+08:00', 'missed')
    entry2 = Entry.new('2017-01-02T12:24:16+08:00', 'partially_completed')
    store.add_habit(habit1)
    store.add_habit(habit2)
    store.add_entry_of(1, entry1)
    store.add_entry_of(2, entry1)
    store.add_entry_of(1, entry2)
    store.add_entry_of(2, entry2)
  end

  after do
    File.delete('test.db')
  end

  describe '#remove_remove_db' do
    it 'should remove habit from database' do
      name = ['workout']
      result = remove_command.remove_from_db(name, store)
      count = store.get_habits_count

      expected = remove_command.feedback(name)

      expect(result).to eq expected
      expect(count).to eq 1
    end

    it 'should remove multiple habits from database' do
      names = ['workout', 'read']
      result = remove_command.remove_from_db(names, store)
      count = store.get_habits_count

      expected = remove_command.feedback(names)

      expect(result).to eq expected
      expect(count).to eq 0
    end

    it 'should display error if habit not found' do
      name = 'apple'
      result = remove_command.remove_from_db(name, store)

      expected = Hbtrack::ErrorHandler.raise_habit_not_found(name)

      expect(result).to eq expected
    end
  end
end
