# frozen_string_literal: true

module Hbtrack
  # This class contains the methods to
  # handle the operation of mutliple habits
  class HabitTracker
    attr_reader :habits, :hp

    def self.help # Refactoring needed
      puts 'usage: hbtrack list [-p] [ habit_name ]'
      puts '       hbtrack add habit_name'
      puts '       hbtrack done [-y] habit_name'
      puts '       hbtrack undone [-y] habit_name'
      puts '       hbtrack remove habit_name'
    end

    def initialize(file = FILE_NAME,
                   output = FILE_NAME)
      @habits = []
      @file_name = file
      @output_file_name = output
      @hp = HabitPrinter.new(CompleteSF.new)
      initialize_habits_from_file
    end

    def parse_arguments(args)
      head = args.shift
      tail = args
      send(head, tail)
    end

    # This methods find a habit based on the name given.
    # Blocks are executed when habit is not found.
    def find(habit_name)
      habit = @habits.find do |h|
        h.name == habit_name
      end
      yield if habit.nil? && block_given?
      habit
    end

    def longest_name
      @habits.max_by(&:name_length).name
    end

    def method_missing(*args)
      HabitTracker.help
    end

    private

    def initialize_habits_from_file
      return unless File.exist?(@file_name)
      input = File.read(@file_name).split(/\n\n/)
      input.each { |string| @habits << Habit.initialize_from_string(string) }
    end

    def list(args)
      habit_name, options = parse_options(args)
      set_sf_based_on(options)
      habit = find(habit_name) do
        if habit_name.nil?
          list_all_habits
        else
         raise_habit_not_found(habit_name)
        end
        return
      end
      puts Util.title habit.name 
      puts @hp.print_all_progress(habit)
    end

    def set_sf_based_on(options)
      return if options.empty?
      if options[0] == '-p'
        @hp = HabitPrinter.new(CompletionRateSF.new)
      end
    end

    def list_all_habits 
      puts Util.title Date.today.strftime("%B %Y")
      @habits.each_with_index do |h, index|
        space = longest_name.length - h.name_length
        puts "#{index + 1}. " +
        "#{@hp.print_latest_progress(h, space)}"
      end
    end

    def add(args)
      habit_name, _options = parse_options(args)
      find(habit_name) do
        habit = create(habit_name)
        save_to_file(habit, 'Add') unless habit.nil?
        return
      end
      puts CLI.blue("#{habit_name} already existed!")
    end

    def done(args)
      habit_name, options = parse_options(args)
      day = get_day_based_on(options)
      habit = find_or_create(habit_name)
      save_to_file(habit, 'Done') do
        habit.done(true, day)
      end
    end

    def undone(args)
      habit_name, options = parse_options(args)
      day = get_day_based_on(options)
      habit = find(habit_name) { raise_if_habit_error(habit_name) }
      save_to_file(habit, 'Undone', 'blue') do
        habit.done(false, day)
      end
    end

    def remove(args)
      habit_name, _options = parse_options(args)
      habit = find(habit_name) { raise_if_habit_error(habit_name) }
      save_to_file(habit, 'Remove', 'blue') do
        @habits.delete(habit)
      end
    end

    def find_or_create(habit_name)
      habit = find(habit_name) do
        habit = create(habit_name)
        return habit
      end
    end

    def create(habit_name)
      unless invalid_habit_name?(habit_name)
        habit = Habit.new(habit_name)
        @habits << habit
        return habit
      end

      if habit_name && habit_name.length > 11 
        raise_habit_name_too_long
      else
        raise_invalid_arguments
      end
    end

    def parse_options(args)
      options = args.select { |x| x =~ /\A-/ }
      args -= options
      [args[0], options]
    end

    def get_day_based_on(options)
      yesterday = options[0] == '-y' || options[0] == '--yesterday'
      return Date.today unless yesterday
      Date.today - 1
    end

    def raise_error_msg(msg)
      puts CLI.red msg 
      return
    end

    def raise_if_habit_error(habit_name)       
      return raise_invalid_arguments if habit_name.nil? 
      raise_habit_not_found(habit_name)
    end        

    def raise_habit_not_found(habit_name)
      raise_error_msg "Invalid argument: #{habit_name} not found."
    end

    def raise_invalid_arguments 
      raise_error_msg "Invalid argument: habit_name is expected."
    end

    def raise_habit_name_too_long
      raise_error_msg "habit_name too long."
    end

    def invalid_habit_name?(habit_name)
      habit_name.nil? || habit_name =~ /\s+/ || 
      habit_name.length > 11
    end

    def save
      File.open(@output_file_name, 'w') do |f|
        @habits.each do |habit|
          f.puts habit
        end
      end
    end

    def save_to_file(habit, action, color = 'green')
      unless habit.nil?
        yield if block_given?
        save
        output = "#{action} #{habit.name}!"
        puts CLI.public_send(color, output)
      end
    end
  end
end
