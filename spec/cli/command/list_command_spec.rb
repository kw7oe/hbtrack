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

  describe '#get_from_db' do
    it 'should get all habits from database if title not provided' do
      habit1, habit2 = Hbtrack::ListCommand.new(nil, nil).get_from_db(store)

      expect(habit1[:title]).to eq 'workout'
      expect(habit2[:title]).to eq 'read'

      expect(habit1[:display_order]).to be 1
      expect(habit2[:display_order]).to be 2
    end

    it 'should get the specfic habit from database if title is provided' do
      habit = Hbtrack::ListCommand.new(nil, nil).get_from_db(store, title: 'workout')

      expect(habit[:title]).to eq 'workout'
      expect(habit[:display_order]).to be 1
    end
  end
end
