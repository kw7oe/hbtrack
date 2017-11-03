# frozen_string_literal: true

require 'optparse'
require 'hbtrack/command'

module Hbtrack
  class ListCommand < Command
    attr_reader :printer, :formatter, :month

    def initialize(hbt, options)
      @percentage = false
      @month = Habit.get_progress_key_from(Date.today)

      super(hbt, options)
      @formatter = @percentage ? CompletionRateSF.new : CompleteSF.new
      @printer = HabitPrinter.new(@formatter)
    end

    def execute
      return list_all(@printer, @month) if @all
      return list(@names[0], @printer) unless @names.empty?
      super
    end

    def create_option_parser
      OptionParser.new do |opts|
        opts.banner = 'Usage: hbtrack list [<habit_name>] [options]'
        opts.separator ''
        opts.separator 'Options:'

        opts.on('-p', '--percentage', 'List habit(s) with completion rate') do
          @percentage = true
        end

        opts.on('-a', '--all', 'List all habits') do
          @all = true
        end

        opts.on('--month MONTH', 'List habit(s) according to month provided') do |month|
          @month = month.to_sym
        end

        opts.on_tail('-h', '--help', 'Prints this help') do
          puts opts
          exit
        end
      end
    end

    def list(name, printer)
      habit = @hbt.find(name) do
        return ErrorHandler.raise_habit_not_found(name)
      end

      title = Util.title habit.name
      progress = printer.print_all_progress(habit)
      footer = "\n" + habit.overall_stat_description(printer.formatter)

      "#{title}#{progress}\n#{footer}"
    end

    def list_all(printer, month_key)
      return Util.blue 'No habits added yet.' if @hbt.habits.empty?

      title = Util.title Util.current_month
      progress = @hbt.habits.each_with_index.map do |h, index|
        space = @hbt.longest_name.length - h.name_length
        "#{index + 1}. " \
        "#{printer.print_progress_for(habit: h, key: month_key,  no_of_space: space)}"
      end.join("\n")
      footer = "\n" + @hbt.overall_stat_description(@formatter)

      "#{title}#{progress}\n#{footer}"
    end
  end
end
