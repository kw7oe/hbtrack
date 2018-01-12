# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hbtrack::Database::SequelStore do
  before :each do
    @store = Hbtrack::Database::SequelStore.start(name: 'test.db')
  end

  after :each do
    File.delete('test.db')
  end

  Habit = Struct.new(:title, :display_order)
  Entry = Struct.new(:timestamp, :type)

  describe 'habits' do
    it 'should be able to add habit' do
      struct = Habit.new("workout", 1)
      @store.add_habit(struct)

      habit = @store.get_habit(1)

      expect(habit[:title]).to eq "workout"
    end

    it 'should be able to get habits count' do
      struct = Habit.new("workout", 1)
      struct2 = Habit.new("workout", 2)
      @store.add_habit(struct)
      @store.add_habit(struct2)
      count = @store.get_habits_count

      expect(count).to eq 2
    end
  end

  describe 'entries' do
    let(:habit) do
      struct = Habit.new("workout", 1)
      @store.add_habit(struct)
      @store.get_habit(1)
    end

    it 'should be able to add entries for a habit' do
      struct = Entry.new('2017-02-26T12:24:16+08:00', 'partially_compleed')
      id = habit[:id]
      @store.add_entry_of(id, struct)
      entries = @store.get_entries_of(id)

      expect(entries.count).to eq 1
    end
  end

end
