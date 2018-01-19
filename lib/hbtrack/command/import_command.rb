# frozen_string_literal: true

require 'optparse'
require 'hbtrack/command'
require 'hbtrack/importer/streaks_importer'
require 'hbtrack/importer/hbtrack_importer'
require 'hbtrack/database/sequel_store'

module Hbtrack
  # ImportCommand class is responsible for handling
  # `hbtrack import` command in CLI
  class ImportCommand < Command
    def initialize(file_path = 'hbtrack.db', options)
      @importer = Hbtrack::Importer::HbtrackImporter.new

      # To allow creation of test.db
      @store = Hbtrack::Database::SequelStore.new(name: file_path)
      super(nil, options)
    end

    def execute
      return import(@names[0])
      super
    end

    def create_option_parser
      OptionParser.new do |opts|
        opts.banner = 'Usage: hbtrack import <file_path> <options>'
        opts.on('--streaks', 'Import data from streaks') do
          @importer = Hbtrack::Importer::StreaksImporter.new
        end
      end
    end

    def import(file_path)
      @importer.import_from(file_path)
      @importer.store_in(local_store)
      Util.green "Succesfully imported from #{file_path}"
    rescue => e
      Util.red "Error: #{e}"
    end

  end
end

