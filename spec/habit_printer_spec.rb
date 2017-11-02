# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hbtrack::HabitPrinter do
    let(:latest_key) { Hbtrack::Habit.get_progress_key_from(Date.today) }
    let(:string) { 
      string = <<~EOF
      workout
      2017,5: 0000000000011111
      2017,6: 0000000000011111
      EOF
      string += latest_key.to_s + ': 1'
      return string
    }
    let(:habit) { Hbtrack::Habit.initialize_from_string(string) }
    let(:hp) { Hbtrack::HabitPrinter.new(Hbtrack::CompleteSF.new) }
    let(:util) { Hbtrack::Util }

    it '#print_latest_progress should return right output' do
      expected_result = 'workout : ' + util.green('*') +
        ' ' * 31 +
        'All: 1, Done: 1, Undone: 0'
      expect(hp.print_latest_progress(habit)).to eq expected_result
    end

    it '#pretty_print_all should return right output' do
      stat = ' ' * 16 +
        'All: 16, Done: 5, Undone: 11'
      progress = util.red('*') * 11 + util.green('*') * 5
      expected_result = util.convert_key_to_date(:"2017,5", hp.calculate_space_needed_for(habit, :"2017,5")) +
        progress + stat + "\n" +
        util.convert_key_to_date(:"2017,6", hp.calculate_space_needed_for(habit, :"2017,6")) +
        progress + stat + "\n" +
        util.convert_key_to_date(latest_key, hp.calculate_space_needed_for(habit, latest_key)) +
        util.green('*') +
        ' ' * 31 +
        'All: 1, Done: 1, Undone: 0'
      expect(hp.print_all_progress(habit)).to eq expected_result
    end
end
