# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Stat Formatter' do
  let(:value) { { done: 5, undone: 11 } }
  let(:util) { Hbtrack::Util }

  it 'DoneUndoneSF#format should return done and undone only' do
    expected_result = util.green('Done: 5') + "\n" +
                      util.red('Undone: 11')
    expect(Hbtrack::DoneUndoneSF.new.format(value)).to eq expected_result
  end

  it 'CompleteSF#format should return done, undone and all' do
    expected_result = 'All: 16, Done: 5, Undone: 11'
    expect(Hbtrack::CompleteSF.new.format(value)).to eq expected_result
  end

  it 'CompletionRate#to_percentage should return hash with correct value' do
    expected_result = { done: 31.25, undone: 68.75 }
    expect(Hbtrack::CompletionRateSF.new.to_percentage(value)).to eq expected_result
  end

  it 'CompletionRate#formate should return completion_rate' do
    expected_result = 'Completion rate: 31.25%'
    expect(Hbtrack::CompletionRateSF.new.format(value)).to eq expected_result
  end
end
