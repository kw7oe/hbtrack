# frozen_string_literal: true

# Configuration for the application.
module Hbtrack
  # File to read during testing
  TEST_FILE = 'test/test_data'

  # File to write to during testing
  OUTPUT_FILE = 'test/test_output'

  # File to store your data
  FILE_NAME = Dir.home + '/.habit'

  # DB file
  DB_PATH = Dir.home + '/.habit.db'
end
