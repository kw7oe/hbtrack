# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hbtrack::Util do
   let(:util) { Hbtrack::Util }

  it '#convert_key_to_date should work' do
    result = util.convert_key_to_date(:'2017,6', 0)
    expected = 'June 2017 : '
    expect(result).to eq expected
  end

  it '#get_date_from should return correct date' do
    result = util.get_date_from(key: :'2017,1')
    expected = Date.new(2017, 1, 1)
    expect(result).to eq expected
  end

  it '#get_month_from should work' do
    result = util.get_month_from(:'2017,1')

    expected = 'January'

    expect(result).to eq expected    
  end
end
