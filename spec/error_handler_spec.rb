require "spec_helper"

RSpec.describe Hbtrack::ErrorHandler do 
  it "should print invalid habit" do 
    result = Hbtrack::Util.red("Invalid habit: workout not found.")
    expect(Hbtrack::ErrorHandler.raise_habit_not_found('workout')).to eq result
  end

  it "should print invalid arguments" do 
    result = Hbtrack::Util.red("Invalid argument: habit_name is expected.")
    expect(Hbtrack::ErrorHandler.raise_invalid_arguments).to eq result
  end

  it "should print habit_name too long" do 
    result = Hbtrack::Util.red("habit_name too long.")
    expect(Hbtrack::ErrorHandler.raise_habit_name_too_long).to eq result
  end

  it "#raise_if_habit_error should print invalid argument if habit_name is nil" do
    result = Hbtrack::Util.red("Invalid argument: habit_name is expected.")
    expect(Hbtrack::ErrorHandler.raise_if_habit_error(nil)).to eq result
  end
  
  it "#raise_if_habit_error should print habit not found if habit_name is present" do
    result = Hbtrack::Util.red("Invalid habit: workout not found.")
    expect(Hbtrack::ErrorHandler.raise_if_habit_error('workout')).to eq result
  end
end


