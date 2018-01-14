# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hbtrack::ListCommand do
  let(:store) { Hbtrack::Database::SequelStore.start(name: 'test.db') }

  before :each do
    titles = ['workout', 'read']
    Hbtrack::AddCommand.new(nil, nil).add_to_db(titles, store)
  end

  after :each do
    File.delete('test.db')
  end

  describe '#get_habits_from_db' do
    it 'should get all habits from database' do
      habits, entries = Hbtrack::ListCommand.new(nil, nil).get_habits_from_db(store)

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
      habit , entry = Hbtrack::ListCommand.new(nil, nil).get_habit_from_db(store, 'workout')

      expect(habit[:title]).to eq 'workout'
      expect(habit[:display_order]).to be 1
    end
  end
end
