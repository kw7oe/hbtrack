# frozen_string_literal: true

require 'optparse'
require 'hbtrack/command'
require 'hbtrack/store'

module Hbtrack
  class UpdateCommand < Command
    def initialize(hbt, options, is_done)
      @day = Date.today
      @is_done = is_done
      super(hbt, options)
    end

    def execute
      return update_all(@day, @is_done) if @all
      return update(@name, @day, @is_done) if @name
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

    def update(name, day, is_done)
      habit = if is_done
                @hbt.find_or_create(name)
              else
                @hbt.find(name) do
                  return ErrorHandler.raise_if_habit_error(name)
                end
              end

      habit.done(is_done, day)

      Store.new(@hbt.habits, @hbt.output_file_name).save

      Hbtrack::Util.green("#{action(is_done)} workout!")
    end

    # TODO: Test needed
    def update_all(day, is_done)
      @hbt.habits.each { |habit| habit.done(is_done, day) }

      Store.new(@hbt.habits, @hbt.output_file_name).save

      Hbtrack::Util.green("#{action(is_done)} all habits!")
    end

    def action(is_done)
      is_done ? 'Done' : 'Undone'
    end
  end
end
