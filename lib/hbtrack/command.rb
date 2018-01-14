# frozen_string_literal: true

module Hbtrack
  class Command
    def initialize(hbt, options)
      @hbt = hbt
      @all = false
      @option_parser = create_option_parser

      unprocess_option = @option_parser.parse(options)
      @names = unprocess_option
    end

    def local_store
      return @store if @store
      @store = SequelStore.new
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
