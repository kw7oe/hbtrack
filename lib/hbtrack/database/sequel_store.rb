# frozen_string_literal: true

module Hbtrack
  module Database
    class SequelStore
      require 'sequel'

      attr_reader :db
      def initialize(name: 'hbtrack.db')
        @db = Sequel.sqlite(name)
        create_table?
      end

      # Add a habit
      def add_habit(habit)
        habits.insert(
          title: habit.title,
          display_order: habit.display_order
        )
      end

      # Delete a habit
      def delete_habit(title)
        habits.where(title: title).delete
      end

      # Get habit by id
      def get_habit(id)
        habits.filter(id: id).first
      end

      # Get ID of a habit by title
      def get_habit_id_for(title)
        get_habit_by_title(title)&.fetch(:id)
      end

      # Get habit by title
      def get_habit_by_title(title)
        habits.filter(title: title).first
      end

      # Get all habits
      def get_all_habits
        habits.all
      end

      # Get count of habits
      def get_habits_count
        habits.count
      end

      # Data Abstrack for Entry
      # Entry = Struct.new(:timestamp, :type, :habit_id)

      # Add a entry of a habit
      def add_entry_of(habit_id, entry)
        entries.insert(
          timestamp: entry.timestamp,
          type: entry.type,
          habit_id: habit_id
        )
      end

      def update_entry_of(habit_id, time, type)
        entries.where(habit_id: habit_id)
          .where(timestamp: day_range_for(time))
          .update(type: type, timestamp: time)
      end

      def get_latest_entry_of(habit_id)
        entries.where(habit_id: habit_id)
          .order(Sequel.desc(:timestamp)).first
      end

      # Get all entries of a habit
      def get_entries_of(habit_id)
        entries.where(habit_id: habit_id)
      end

      # Get entries count of a habit
      def get_entries_count_of(habit_id)
        get_entries_of(habit_id).count
      end

      # Get entries of a habit in a period of month
      # according to month and year given.
      def get_entries_of_month(habit_id, month, year)
        get_entries_of(habit_id)
          .where(timestamp: month_range(month, year))
          .all
      end

      # Create a range of date from the first day
      # to the last day of a month
      def month_range(month, year)
        next_month = month == 12 ? 1 : month + 1
        next_year = month == 12 ? year + 1 : year
        Date.new(year, month, 1)..Date.new(next_year, next_month, 1)
      end

      # Create a range from the start of a day
      # to the end of a day according to the
      # DateTime object given.
      def day_range_for(time)
        year = time.year
        month = time.month
        day = time.day
        timezone = Time.new.zone

        Range.new(
          DateTime.new(year, month, day, 0, 0, 0, timezone),
          DateTime.new(year, month, day, 23, 59, 59, timezone)
        )
      end

      private
      # Create Habits and Entries table if doesn't exist
      def create_table?
        db.create_table? :habits do
          primary_key :id
          String :title
          Integer :display_order
        end

        db.create_table? :entries do
          primary_key :id
          String :type
          DateTime :timestamp
          foreign_key :habit_id, :habits, on_delete: :cascade
        end
      end

      # Get Habits dataset
      def habits
        return @habits if @habit
        @habits = db[:habits]
      end

      # Get Entries dataset
      def entries
        return @entries if @entries
        @entries = db[:entries]
      end
    end
  end
end
