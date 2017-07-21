# frozen_string_literal: true

require 'date'
require 'hbtrack/cli'

module Hbtrack
  # Habit provide a rich library to track the
  # progress of your habit.
  class Habit
    attr_accessor :name
    attr_reader :progress

    # Class Methods

    class << self
      # Generate hash key for progress based
      # on date.
      #
      # Example
      #
      #   Habit.get_progress_key_from(Date.new(2017, 7, 18))
      #   # => :"2017,7"
      def get_progress_key_from(date)
        date.strftime('%Y,%-m').to_sym
      end

      # Initialize Habit object from string.
      #
      # string - The string to be parse.
      #
      # Example
      #
      #   Habit.initialize_from_string("workout\n2017,6:1001")
      #   # => #<Habit:0x007f9be6041b70 @name="workout",
      #   #    @progress={:"2017,6"=>"1001"}>
      #
      #   Habit.initialize_from_string("")
      #   # => nil
      def initialize_from_string(string)
        return nil if string.empty?
        arr = string.split("\n")
        habit_name = arr.shift
        hash = {}
        arr.each do |s|
          a = s.split(': ')
          value = a[1] ? a[1] : ''
          hash[a[0].to_sym] = value
        end
        Habit.new(habit_name, hash)
      end
    end

    # Public APIs

    def initialize(name,
                   progress = {
                     Habit.get_progress_key_from(Date.today) => ''
                   })
      @name = name
      @progress = progress
    end

    def name_length
      name.length
    end

    def latest_key
      Habit.get_progress_key_from(Date.today)
    end

    def latest_progress
      progress[latest_key]
    end

    def longest_month
      key = progress.keys.max_by do |x| 
        get_month_from(x).length
      end
      get_month_from(key)
    end

    def done(done = true, date = Date.today)
      key = Habit.get_progress_key_from(date)
      initialize_progress_hash_from(key)
      update_progress_for(key, date.day, done)
    end

    def pretty_print_all
      @progress.map do |key, _value|
        space = longest_month.length - get_month_from(key).length 
        convert_key_to_date(key, space) +
        pretty_print_progress(key)
      end.join("\n")
    end

    def pretty_print_latest(no_of_space = 0)
      name.to_s + ' ' * no_of_space + ' : ' +
        pretty_print_progress(latest_key)
    end

    def pretty_print_progress(key)
      stat = progress[key].split('').map do |x|
        x == '0' ? Hbtrack::CLI.red('*') : Hbtrack::CLI.green('*')
      end.join('')
      stat + ' ' * (32 - progress[key].size) +
        one_liner_progress_stat_output_for(key)
    end

    def convert_key_to_date(key, no_of_space)
      year = key.to_s.split(",")[0]
      ' ' * no_of_space + get_month_from(key) + 
      " #{year}" + " : "
    end

    def get_month_from(key)
      key = key.to_s.split(',')
      Date::MONTHNAMES[key[1].to_i]
    end

    # Get all of the progress of the habit in string form
    #
    # Example:
    #
    #   habit.progress_output
    #   # => "2017,5: 0010001010\n2017,6: 000010010\n"
    #
    def progress_output
      arr = @progress.map do |key, value|
        "#{key}: #{value}\n"
      end
      arr.join('')
    end

    def progress_stat
      @progress.map do |key, _value|
        convert_key_to_date(key, 0) + "\n" +
          progress_stat_output_for(key)
      end.join("\n")
    end

    def one_liner_progress_stat_output_for(key)
      hash = progress_stat_for(key)
      "(All: #{progress[key].size}," \
        " Done: #{hash[:done]}, Undone: #{hash[:undone]})"
    end

    def progress_stat_output_for(key)
      hash = progress_stat_for(key)
      Hbtrack::CLI.green("Done: #{hash[:done]}") + "\n" +
        Hbtrack::CLI.red("Undone: #{hash[:undone]}") + "\n"
    end

    # Get the stat of the progress.
    #
    # key - Key for the progress (hash)
    #
    # Example:
    #
    #   habit.progress_stat_for("2017,5".to_sym)
    #   # => { done: 5, undone: 2 }
    def progress_stat_for(key)
      undone = @progress[key].split('').count { |x| x == '0' }
      done = @progress[key].length - undone
      { done: done, undone: undone }
    end

    def to_s
      "#{name}\n" + progress_output + "\n"
    end

    # Private APIs

    private

    def initialize_progress_hash_from(key)
      @progress[key] = '' unless @progress.key? key
    end

    def update_progress_for(key, day, done)
      i = day - @progress[key].length - 1
      result = @progress[key].split('')
      i.times { result << '0' }
      result[day] = done ? '1' : '0'
      @progress[key] = result.join('')
    end
  end
end
