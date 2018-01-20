# frozen_string_literal: true

require 'spec_helper'

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

  describe '#get_habit_from_db' do
    it 'should get the specfic habit from database' do
      habit, entry = show_command.get_habit_from_db(store, 'workout')

      expect(habit[:title]).to eq 'workout'
      expect(habit[:display_order]).to be 1

      expect(entry['2017-01'][0][:type]).to eq 'missed'
    end
  end
end
