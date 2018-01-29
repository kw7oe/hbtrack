# frozen_string_literal: true

# TODO: Reorganise import files
require 'hbtrack/config'
require 'hbtrack/stat_formatter'
require 'hbtrack/importer/streaks_importer'
require 'hbtrack/importer/hbtrack_importer'
require 'hbtrack/database/sequel_store'
require 'hbtrack/error_handler'
require 'hbtrack/cli/cli'

module Hbtrack
  class << self
    def run(args)
      CLI.run(args)
    end
  end
end
