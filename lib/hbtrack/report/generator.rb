# frozen_string_literal: true

require 'erb'
require 'hbtrack/report/calendar'

module Hbtrack
  class Generator 
    def initialize(hbt)
      @hbt = hbt
      initialize_stat
      @week_days = Hbtrack::Calendar::WEEKDAYS
      @weeks = Hbtrack::Calendar.weeks(Date.today)
    end

    def initialize_stat
      @stat = @hbt.total_habits_stat
      @stat[:total] = @stat[:done] + @stat[:undone]
      @stat[:percentage] = (@stat[:done] / @stat[:total].to_f).round(2) * 100
    end

    def td_for(date)
      Hbtrack::Calendar.td_for(date, @hbt.habits.last.latest_progress)
    end

    def generate
      file_path = File.expand_path("../report.html.erb", __FILE__)
      renderer = ERB.new(File.read(file_path))
      File.write('report.html', renderer.result(binding))
    end    
  end
end
