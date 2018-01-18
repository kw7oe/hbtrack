# frozen_string_literal: true

require 'optparse'
require 'hbtrack/command'
require 'hbtrack/cli/view'

module Hbtrack
  class ListCommand < Command
    attr_reader :printer, :formatter, :month

    def initialize(hbt, options)
      @percentage = false
      @month = Habit.get_progress_key_from(Date.today)
      @db = false

      super(hbt, options)
      @formatter = @percentage ? CompletionRateSF.new : CompleteSF.new
      @printer = HabitPrinter.new(@formatter)
    end

    def execute
      return list_from_db(local_store, @names) if @db
      unless @names.empty?
        return list(@names[0])
      end
      return list_all(@month)
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

        opts.on('--db', 'List habit(s) from database') do
          @db = true
        end


        # TODO: Renamed to better describe the functionality
        #       as in this case user are required toe enter
        #       the input in the form of <year>,<month>
        opts.on('-m', '--month MONTH', 'List habit(s) according to month provided') do |month|
          @month = month.to_sym
          @year, @mon = month.split(',')
        end

        opts.on_tail('-h', '--help', 'Prints this help') do
          puts opts
          exit
        end
      end
    end

    def list(name)
      habit = @hbt.find habit_name: name, if_fail: (proc do
        return ErrorHandler.raise_habit_not_found(name)
      end)
      feedback_single(habit)
    end

    def feedback_single(habit)
      title = Util.title habit.name
      progress = printer.print_all_progress(habit)
      footer = "\n" + habit.overall_stat_description(printer.formatter)
      "#{title}#{progress}\n#{footer}"
    end

    def list_all(month_key)
      return Util.blue 'No habits added yet.' if @hbt.habits.empty?
      return Util.red 'Invalid month provided.' if @hbt.invalid_key? month_key

      date = Util.get_date_from(key: month_key)
      title = Util.title date.strftime('%B %Y')
      longest_name_length = @hbt.longest_name.length

      progress = @hbt.habits.each_with_index.map do |h, index|
        space = longest_name_length - h.name.length
        get_output_of(habit: h,
                      number: index + 1,
                      space: space,
                      key: month_key)
      end.join("\n")
      footer = "\n" + @hbt.overall_stat_description_for(key: month_key, formatter: @formatter)

      "#{title}#{progress}\n#{footer}"
    end

    def get_output_of(habit:, number:, space:, key:)
      progress = printer.print_progress_for(habit: habit,
                                            key: key,
                                            no_of_space: space)
      "#{number}. #{progress}"
    end

    def list_from_db(store, names)
      habits = []
      habits, entries = if names.empty?
                          get_habits_from_db(store)
                        else
                          get_habit_from_db(store, title: names[0])
                        end
      Hbtrack::CLI::View.list_all_habits(habits, entries, @month)
    end

    def get_habits_from_db(store)
      habits = []
      entries = {}
      habits = store.get_all_habits
      habits.each do |habit|
        entries[habit[:title]] = get_entry_from_db(store, habit[:id])
      end
      [habits, entries]
    end

    def get_habit_from_db(store, title)
      entry = {}
      habit = store.get_habit_by_title(title)
      entry[habit[:title]] = get_entry_from_db(store, habit[:id])
      [habit, entry]
    end

    def get_entry_from_db(store, id)
      month = @mon.to_i || Date.today.month
      year = @year.to_i || Date.today.year
      store.get_entries_of_month(id, month, year)
    end
  end
end
