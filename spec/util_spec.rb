# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hbtrack::Util do
  before do
    @util = Hbtrack::Util
  end

  it '#convert_key_to_date should work' do
    result = @util.convert_key_to_date(:'2017,6', 0)

    expected = 'June 2017 : '

    expect(result).to eq expected
  end

  it '#get_month_from should work' do
    result = @util.get_month_from(:'2017,1')

    expected = 'January'

    expect(result).to eq expected    
  end
end
