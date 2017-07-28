# frozen_string_literal: true

require 'date'

module Hbtrack # Habit provide a rich library to track the
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
      # @param string [String] The string to be parse.
      # @return [Habit] a habit object
      #
      # == Example
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

    def initialize(name,
                   progress = {
                     Habit.get_progress_key_from(Date.today) => ''
                   })
      @name = name
      @progress = progress
    end

    # The length of the habit name.
    #
    # @return [Numeric] length of the habit name
    def name_length
      name.length
    end

    # Get the latest progress key.
    # 
    # @return [Symbol] latest progress key
    def latest_key  
      Habit.get_progress_key_from(Date.today)
    end

    # Get the latest progress.
    #
    # @return [String] value of the progress
    def latest_progress
      progress[latest_key]
    end

    # Find the month in progress with 
    # the longest name
    # 
    # @return [String] month
    def longest_month
      key = progress.keys.max_by do |x| 
        Util.get_month_from(x).length
      end
      Util.get_month_from(key)
    end

    # Update the status of the progress
    #
    # @param done [true, false] If true, it is marked as done. 
    #   Else, marked as undone.
    # @param date [Date] The date of the progress
    # @return [void]
    def done(done = true, date = Date.today)
      key = Habit.get_progress_key_from(date)
      initialize_progress_hash_from(key)
      update_progress_for(key, date.day, done)
    end

    # Get the stat of the progress.
    #
    # @param key [Symbol] key for the progress
    # @return [Hash] stat of the progress in the form of 
    # == Example:
    #
    #   habit.stat_for_progress("2017,5".to_sym)
    #   # => { done: 5, undone: 2 }
    def stat_for_progress(key)
      undone = @progress[key].split('').count { |x| x == '0' }
      done = @progress[key].length - undone
      { done: done, undone: undone }
    end

    # Get all of the progress of the habit in string form
    #
    # == Example:
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

    def pretty_print_all
      @progress.map do |key, _value|
        space = longest_month.length - Util.get_month_from(key).length 
        Util.convert_key_to_date(key, space) +
        pretty_print_progress(key)
      end.join("\n")
    end

    def pretty_print_latest(no_of_space = 0)
      name.to_s + ' ' * no_of_space + ' : ' +
        pretty_print_progress(latest_key)
    end

    def pretty_print_progress(key)
      stat = progress[key].split('').map do |x|
        x == '0' ? CLI.red('*') : CLI.green('*')
      end.join('')
      stat + ' ' * (32 - progress[key].size) +
        StatFormatter.complete(stat_for_progress(key))
    end

    def to_s
      "#{name}\n" + progress_output + "\n"
    end

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
