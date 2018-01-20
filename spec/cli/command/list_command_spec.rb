# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hbtrack::ListCommand do
  let(:store) { Hbtrack::Database::SequelStore.new(name: 'test.db') }
  let(:list_command) { Hbtrack::ListCommand.new(nil, ['--month', '2017,1']) }

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

  describe '#get_habits_from_db' do
    it 'should get all habits from database' do
      habits, entries = list_command.get_habits_from_db(store)

      habit1 = habits[0]
      habit2 = habits[1]

      expect(habit1[:title]).to eq 'workout'
      expect(habit2[:title]).to eq 'read'

      expect(habit1[:display_order]).to eq 1
      expect(habit2[:display_order]).to eq 2

      entry1 = entries['workout'][0]
      entry2 = entries['read'][1]

      expect(entry1[:type]).to eq 'missed'
      expect(entry2[:type]).to eq 'partially_completed'
    end
  end
end
