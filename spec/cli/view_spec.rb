# frozen_string_literal: true

require 'spec_helper'
require 'hbtrack/util'
require 'hbtrack/cli/view'

RSpec.describe Hbtrack::CLI::View do

  View = Hbtrack::CLI::View
  Util = Hbtrack::Util

  describe '#convert_entry_to_view' do
    it 'should convert entry correctly' do
      entry = [
        {type: 'missed_auto'},
        {type: 'partially_completed'},
        {type: 'skip'},
        {type: 'missed'},
        {type: 'missed'},
        {type: 'completed_manually'},
        {type: 'completed_auto'},
      ]

      result = View.convert_entry_to_view(entry)
      expected = Util.red('*') * 5 + Util.green('*') * 2

      expect(result).to eq expected
    end
  end

  describe '#convert_status_to_view' do
    it 'should create red * when is partially completed' do
      result = View.convert_status_to_view('partially_completed')
      expected = Util.red('*')
      expect(result).to eq expected
    end

    it 'should create red * when is missed' do
      result = View.convert_status_to_view('missed')
      expected = Util.red('*')
      expect(result).to eq expected
    end

    it 'should create green * when is completed' do
      result = View.convert_status_to_view('completed')
      expected = Util.green('*')
      expect(result).to eq expected
    end
  end

end
