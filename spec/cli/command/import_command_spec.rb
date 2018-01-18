# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hbtrack::ImportCommand do
  after do
    File.delete('test.db')
  end

  describe '#execute' do
    it 'it should import using HbtrackImporter by default' do
      import_command = Hbtrack::ImportCommand.new('test.db', 'test/test_data')
      import_command.execute
      habits = import_command.local_store.get_all_habits

      expect(habits[0][:title]).to eq 'workout'
      expect(habits[1][:title]).to eq 'read'
    end

    it 'it should import using StreaksImporter if streaks option is provided' do
      import_command = Hbtrack::ImportCommand.new('test.db', ['test/streaks.csv', '--streaks'])
      import_command.execute
      habits = import_command.local_store.get_all_habits

      expect(habits[0][:title]).to eq 'Wake Up Before 7.30'
      expect(habits[1][:title]).to eq 'Work Out for 5 Minutes'
    end

  end
end
