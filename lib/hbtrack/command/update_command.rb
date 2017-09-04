# frozen_string_literal: true

require 'optparse'
require 'hbtrack/command'
require 'hbtrack/store'

module Hbtrack
  class UpdateCommand < Command
    def initialize(hbt, options, isDone)
      @day = Date.today
      @isDone = isDone
      super(hbt, options)
    end

    def execute
      return update(@name, @day, @isDone) if @name
      super
    end

    def create_option_parser
      OptionParser.new do |opts|
        opts.banner = 'Usage: hbtrack done/undone [<habit_name>] [options]'

        opts.on('-a', '--all', 'Done/Undone all habits') do
          @all = true
        end

        opts.on('-y', '--yesterday', 'Done/Undone habit(s) for yesterday') do
          @day = Date.today - 1
        end

        opts.on('-h', '--help', 'Prints this help') do
          puts opts
          exit
        end
      end
    end

    def update(name, day, isDone)
      habit = if isDone
                @hbt.find_or_create(name)
              else
                @hbt.find(name) do
                  ErrorHandler.raise_if_habit_error(name)
                  exit
                end
              end
      habit.done(isDone, day)
      Store.new(@hbt.habits, @hbt.output_file_name).save
      Hbtrack::Util.green("#{action(isDone)} workout!")
    end

    def update_all(_day, isDone)
      @hbt.habits.each { |habit| habit.done(isDone) }
      Store.new(@hbt.habits, @hbt.output_file_name).save
    end

    def action(isDone)
      isDone ? 'Done' : 'Undone'
    end
  end
end
