# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hbtrack::AddCommand do
  before do
    @hbt = Hbtrack::HabitTracker.new(
      Hbtrack::TEST_FILE,
      Hbtrack::OUTPUT_FILE
    )
    @command = Hbtrack::AddCommand.new(@hbt, ['sleeping'])
  end

  context '#execute' do 
    it 'should call #add when names is provided' do      
      result = @command.execute

      @hbt.habits = [] # Clear previously added habit

      expected = @command.add(['sleeping'])

      expect(result).to eq expected    
    end
  end
  

  context '#add' do 
    before do 
      @initial_count = @hbt.habits.count
    end

    it 'should add a habit' do      
      result = @command.add(['sleeping'])
      result_count = @hbt.habits.count

      expected = Hbtrack::Util.green('Add sleeping!')
      expected_count = @initial_count + 1

      expect(result).to eq expected    
      expect(result_count).to eq(expected_count)
    end

    it 'should add multiple habits' do
      result = @command.add(['sleeping', 'eating'])
      result_count = @hbt.habits.count
      
      expected = Hbtrack::Util.green('Add sleeping,eating!')
      expected_count = @initial_count + 2

      expect(result).to eq expected
      expect(result_count).to eq expected_count
    end

    it 'should not add duplicated entries' do 
      result = @command.add(['sleeping', 'workout'])
      result_count = @hbt.habits.count
      
      expected = Hbtrack::Util.green('Add sleeping!') + "\n" + Hbtrack::Util.blue('workout already existed!')
      expected_count = @initial_count + 1

      expect(result).to eq expected
      expect(result_count).to eq expected_count
    end
  end
  
end
