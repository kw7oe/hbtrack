# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hbtrack::AddCommand do
  let(:store) { Hbtrack::Database::SequelStore.new(name: 'test.db') }
  let(:add_command) { Hbtrack::AddCommand.new(nil, nil, nil) }

  after do
    File.delete('test.db')
  end

  describe '#add_to_db' do
    it 'should store habits to database' do
      names = ['workout', 'read']
      add_command.add_to_db(names, store)

      count = store.get_habits_count
      habit1 = store.get_habit(1)
      habit2 = store.get_habit(2)

      expect(habit1[:title]).to eq 'workout'
      expect(habit2[:title]).to eq 'read'

      expect(habit1[:display_order]).to be 1
      expect(habit2[:display_order]).to be 2
      expect(count).to eq 2
    end
  end
end
