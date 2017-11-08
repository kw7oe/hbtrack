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
      return add(@names) unless @names.empty?
      super
    end

    def create_option_parser
      OptionParser.new do |opts|
        opts.banner = 'Usage: hbtrack add [<habit_name>]'
      end
    end

    def add(names)
      added = []
      names.each do |name|
        @hbt.find habit_name: name, if_fail: (proc do
          @hbt.create(name)
          added << name
        end)
      end

      Store.new(@hbt.habits, @hbt.output_file_name).save

      output = [
        Hbtrack::Util.green("Add #{added.join(',')}!")
      ]

      names -= added
      unless names.empty?
        output << "\n"
        output << Hbtrack::Util.blue("#{names.join(',')} already existed!")
      end

      output.join
    end
  end
end
