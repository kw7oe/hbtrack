# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hbtrack::CLI do

  describe '#help' do
    it 'should display help message' do
      expect { Hbtrack::CLI.help }.to output(//).to_stdout
        .and raise_error SystemExit
    end
  end
end
