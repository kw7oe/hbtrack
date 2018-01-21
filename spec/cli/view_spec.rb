# frozen_string_literal: true

require 'spec_helper'
require 'hbtrack/util'
require 'hbtrack/cli/view'

RSpec.describe Hbtrack::CLI::View do

  View = Hbtrack::CLI::View
  Util = Hbtrack::Util
  let(:entries) do
    [
      {type: 'missed_auto'},
      {type: 'partially_completed'},
      {type: 'skip'},
      {type: 'missed'},
      {type: 'missed'},
      {type: 'completed_manually'},
      {type: 'completed_auto'},
    ]
  end
  let(:habits) do
    [
      {title: 'workout'},
      {title: 'programming'}
    ]
  end
  let(:habit_entries) do
    {
      'workout' => entries,
      'programming' => entries
    }
  end
  let(:workout_entries) do
    {
      "September 2017": entries,
      "October 2017": entries
    }
  end
  let(:expected_entry_string) do
    Util.red('*') * 5 + Util.green('*') * 2
  end

  describe '#list_all_habits' do
    it 'should print the date title and habits with progress' do
      result = View.list_all_habits(habits, habit_entries, '2017,7')
      expected = "July 2017\n---------\n" + View.print_habits(habits, habit_entries)

      expect(result).to eq expected
    end
  end

  describe '#list_habit' do
    it 'should print the habit title and its entries' do
      result = View.list_habit(habits[0], workout_entries)
      expected = "workout\n-------\n" + View.print_entries(workout_entries)

      expect(result).to eq expected
    end
  end

  describe '#print_entry' do
    it 'should print the entries with month and year' do
      result = View.print_entries(workout_entries)
      expected = "September 2017 : " + expected_entry_string +
        "\nOctober 2017   : " + expected_entry_string

      expect(result).to eq expected
    end
  end

  describe '#print_entry' do
    it 'should print the entries with month and year' do
      month = workout_entries.keys[0]
      entry = workout_entries.values[0]
      result = View.print_entry(month, entry, 0)
      expected = "September 2017 : " + expected_entry_string

      expect(result).to eq expected
    end
  end

  describe '#print_habits' do
    it 'should print a list of habits associated with its progress' do
      result = View.print_habits(habits, habit_entries)
      expected = '1. workout     : ' + expected_entry_string +
        "\n2. programming : " + expected_entry_string

      expect(result).to eq expected
    end
  end

  describe '#print_habit' do
    it 'should print habit name and progress' do
      title = 'workout'
      result = View.print_habit(1, title, entries)
      expected = "1. #{title} : " + expected_entry_string

      expect(result).to eq expected
    end
  end

  describe '#convert_entry_to_view' do
    it 'should convert entry correctly' do
      result = View.convert_entry_to_view(entries)
      expect(result).to eq expected_entry_string
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

  describe '#max_char_count' do
    it 'should return the maximum char count among an array of string' do
      input = ['workout', 'programming', 'sleep']
      result = View.max_char_count(input)
      expected = 'programming'.size
      expect(result).to eq expected
    end
  end

end
