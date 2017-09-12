# frozen_string_literal: true

require 'optparse'
require 'hbtrack/command'
require 'hbtrack/store'

module Hbtrack
  class UpdateCommand < Command
    def initialize(hbt, options, is_done)
      @day = Date.today
      @is_done = is_done
      @remaining = false
      super(hbt, options)
    end

    def execute
      return update_remaining(@day, @is_done) if @remaining
      return update_all(@day, @is_done) if @all
      return update(@names, @day, @is_done) if @names
      super
    end

    def create_option_parser
      action = @is_done ? 'Done' : 'Undone'
      OptionParser.new do |opts|
        opts.banner = "Usage: hbtrack #{action.downcase} [<habit_name>] [options]"
        opts.separator ''
        opts.separator 'Options:'
        opts.on('-a', '--all', "#{action} all habits") do
          @all = true
        end

        opts.on('-r', '--remaining', "#{action} remaining habits") do
          @remaining = true
        end

        opts.on('-y', '--yesterday', "#{action} habit(s) for yesterday") do
          @day = Date.today - 1
        end

        opts.on('--day DAY', OptionParser::OctalInteger, "#{action} habit(s) for specific day") do |day|
          @day = Date.new(Date.today.year, Date.today.month, day.to_i)
        end

        opts.on('-h', '--help', 'Prints this help') do
          puts opts
          exit
        end
      end
    end

    def update(names, day, is_done)
      names.each do |name|
        habit = if is_done
                  @hbt.find_or_create(name)
                else
                  @hbt.find(name) do
                    return ErrorHandler.raise_if_habit_error(name)
                  end
                end

        habit.done(is_done, day)
      end

      Store.new(@hbt.habits, @hbt.output_file_name).save

      Hbtrack::Util.green("#{action(is_done)} #{names.join(',')}!")
    end

    def update_all(day, is_done)
      @hbt.habits.each { |habit| habit.done(is_done, day) }

      Store.new(@hbt.habits, @hbt.output_file_name).save

      Hbtrack::Util.green("#{action(is_done)} all habits!")
    end

    def update_remaining(day, is_done)
      @hbt.habits.each do |habit|
        habit.done(is_done, day) if habit.done_for(date: day).nil?
      end

      Store.new(@hbt.habits, @hbt.output_file_name).save

      Hbtrack::Util.green("#{action(is_done)} remaining habit(s)!")
    end

    private

    def action(is_done)
      is_done ? 'Done' : 'Undone'
    end
  end
end
