# frozen_string_literal: true

require 'optparse'

module Hbtrack
  class ListCommand
    def initialize(hbt, options)
      @hbt = hbt
      @options = options
    end

    def execute
      OptionParser.new do |opts|
        opts.banner = "Usage: hbtrack list [<habit_name>] [options]"

        printer = HabitPrinter.new

        opts.on("-a", "--all", "List all habits") do
          list_all(printer)
        end

        opts.on(String, "-p", "--percentage", "List habits with completion rate") do |habit_name|
          printer = HabitPrinter.new(CompletionRateSF.new)
          list(habit_name, printer)
        end

      end.parse(@options)
    end

    def list(name, printer)
      habit = @hbt.find(name) do
        ErrorHandler.raise_habit_not_found(habit_name)
      end
      puts Util.title habit.name
      puts printer.print_all_progress(habit)
      puts "\n" + habit.overall_stat_description(printer.formatter)
    end

    def list_all(printer)
      puts Util.title Util.current_month
      @hbt.habits.each_with_index do |h, index|
        space = @hbt.longest_name.length - h.name_length
        puts "#{index + 1}. " \
        "#{printer.print_latest_progress(h, space)}"
      end
      puts "\n" + @hbt.overall_stat_description
    end
  end
end
