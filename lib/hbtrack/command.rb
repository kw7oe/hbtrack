# frozen_string_literal: true

require 'optparse'

module Hbtrack
  class ListCommand
    attr_reader :printer
    def initialize(hbt, options)
      @hbt = hbt
      @percentage = false
      @all = false
      @printer = HabitPrinter.new
      @options = parse_options
      leftover = @options.parse(options)
      @name = leftover.first
      @printer.formatter = CompletionRateSF.new if @percentage
    end

    def execute
      return list_all(@printer) if @all
      return list(@name, @printer) if @name
      help
    end

    def parse_options
      OptionParser.new do |opts|
        opts.banner = 'Usage: hbtrack list [<habit_name>] [options]'

        opts.on('-p', '--percentage', 'List habit(s) with completion rate') do
          @percentage = true
        end

        opts.on('-a', '--all', 'List all habits') do
          @all = true
        end

        opts.on_tail('-h', '--help', 'Prints this help') do
          puts opts
          exit
        end
      end
    end

    def help
      @options.help
    end

    def list(name, printer)
      habit = @hbt.find(name) do
        ErrorHandler.raise_habit_not_found(name)
        exit
      end

      title = Util.title habit.name
      progress = printer.print_all_progress(habit)
      footer = "\n" + habit.overall_stat_description(printer.formatter)

      "#{title}#{progress}\n#{footer}"
    end

    def list_all(printer)
      title = Util.title Util.current_month
      progress = @hbt.habits.each_with_index.map do |h, index|
        space = @hbt.longest_name.length - h.name_length
        "#{index + 1}. " \
        "#{printer.print_latest_progress(h, space)}"
      end.join("\n")
      footer = "\n" + @hbt.overall_stat_description

      "#{title}#{progress}\n#{footer}"
    end
  end
end
