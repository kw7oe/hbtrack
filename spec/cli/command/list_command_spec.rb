# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hbtrack::ListCommand do
  let(:store) { Hbtrack::Database::SequelStore.new(name: 'test.db') }
  let(:add_command) { Hbtrack::AddCommand.new(nil, nil, nil) }
  let(:list_command) { Hbtrack::ListCommand.new(nil, nil, nil) }

  before do
    titles = ['workout', 'read']
    add_command.add_to_db(titles, store)
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

      expect(habit1[:display_order]).to be 1
      expect(habit2[:display_order]).to be 2
    end
  end

  describe '#get_habit_from_db' do
    it 'should get the specfic habit from database' do
      habit , entry = list_command.get_habit_from_db(store, 'workout')

      expect(habit[:title]).to eq 'workout'
      expect(habit[:display_order]).to be 1
    end
  end
end
