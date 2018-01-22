# frozen_string_literal: true

require 'spec_helper'
require 'hbtrack/util'

RSpec.describe Hbtrack::ImportCommand do
  after do
    File.delete('test.db')
  end

  describe '#execute' do
    it 'it should import using HbtrackImporter by default' do
      import_command = Hbtrack::ImportCommand.new('test.db', 'test/test_data')
      output = import_command.execute
      habits = import_command.local_store.get_all_habits

      expect(output).to eq Hbtrack::Util.green 'Succesfully imported from test/test_data'
      expect(habits[0][:title]).to eq 'workout'
      expect(habits[1][:title]).to eq 'read'
    end

    it 'it should import using StreaksImporter if streaks option is provided' do
      import_command = Hbtrack::ImportCommand.new('test.db', ['test/streaks.csv', '--streaks'])
      output = import_command.execute
      habits = import_command.local_store.get_all_habits

      expect(output).to eq Hbtrack::Util.green 'Succesfully imported from test/streaks.csv'
      expect(habits[0][:title]).to eq 'Wake Up Before 7.30'
      expect(habits[1][:title]).to eq 'Work Out for 5 Minutes'
    end
  end

  describe '#import' do
    it 'should show error if file not found' do
      import_command = Hbtrack::ImportCommand.new('test.db', ['nofile'])
      output = import_command.execute

      expect(output).to eq Hbtrack::Util.red 'Error: File not found'
    end
  end
end
