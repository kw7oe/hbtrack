# frozen_string_literal: true

module Hbtrack
  module Database
    module SequelStore
      extend self
      require 'sequel'

      def start(path: 'sqlite://hbtrack.db')
        db = connect(path)
        initialize(db)
      end

      def connect(path)
        Sequel.connect(path)
      end

      def initialize(db)

        db.create_table? :habits do
          primary_key :id
          String :name
          Integer :page
          Integer :display_order
        end

        db.create_table? :entries do
          primary_key :id
          DateTime :timestamp
          foreign_key :habit_id, :habits
        end
      end

    end
  end
end
