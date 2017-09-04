# frozen_string_literal: true

module Hbtrack
  class Command
    def initialize(hbt, options)
      @hbt = hbt
      @all = false
      @option_parser = create_option_parser

      unprocess_option = @option_parser.parse(options)
      @name = unprocess_option.first
    end

    def execute
      help
    end

    def create_option_parser
      raise 'Not Implemented'
    end

    def help
      @option_parser.help
    end
  end
end
