# frozen_string_literal: true

require 'hbtrack/database/sequel_store'

module Hbtrack
  class Command
    def initialize(store_path, options)
      @all = false
      @option_parser = create_option_parser
      @store_path = store_path
      unprocess_option = @option_parser.parse(options)
      @names = unprocess_option
    end

    def local_store
      @store ||= Hbtrack::Database::SequelStore.new(name: @store_path)
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
