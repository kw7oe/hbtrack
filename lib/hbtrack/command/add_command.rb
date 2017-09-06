# frozen_string_literal: true

require 'optparse'
require 'hbtrack/command'
require 'hbtrack/store'

module Hbtrack
  class AddCommand < Command
    def initialize(hbt, options)
      super(hbt, options)
    end

    def execute
      return add(@name) if @name
      super
    end

    def create_option_parser
      OptionParser.new do |opts|
        opts.banner = 'Usage: hbtrack add [<habit_name>]'

        opts.on('-h', '--help', 'Prints this help') do
          puts opts
          exit
        end
      end
    end

    def add(name)
      @hbt.find(name) do
        @hbt.create(name)
        Store.new(@hbt.habits, @hbt.output_file_name).save
        return Hbtrack::Util.green("Add #{name}!")
      end
      Hbtrack::Util.blue("#{name} already existed!")
    end
  end
end
