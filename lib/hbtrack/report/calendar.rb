module Hbtrack
  class Calendar

    WEEKDAYS = [
      "Mon", 
      "Tue", 
      "Wed", 
      "Thu",
      "Fri",
      "Sat",
      "Sun"
    ]

    # Generate weeks of the current month, 
    # which contains 7 days.
    def self.weeks(date)
      range = date.beginning_of_month..date.end_of_month
      result = range.chunk_while { |date| date.cwday < 7 }.to_a

      if result.first.length < 7 
        (7 - result.first.length).times do 
          result.first.unshift(NullDay.new)
        end
      end

      if result.last.length < 7 
        (7 - result.last.length).times do 
          result.last.push(NullDay.new)
        end
      end
      
      result
    end

    # Generate <td> elements for days
    def self.td_for(date, progress)
      progress = progress.split("")

      className = if date.day.nil?
        "null_day"      
      elsif progress[date.day - 1] == "1"
        "done"
      elsif progress[date.day - 1] == "0"
        "undone"
      end
      
      string = <<~EOF
      <td>
        <p class="#{className}">
          #{add_padding_to(date.day)}
        </p>
      </td>
      EOF
    end

    def self.add_padding_to(day)
      return nil if day.nil?
      return "0#{day}" if day < 10 
      day.to_s
    end

  end

  # Null Object Pattern
  class NullDay 
    attr_reader :day
    def initialize
      @day = nil
    end
  end


end

# Extend Date Class
class Date
  def beginning_of_month
    Date.new(self.year, self.month, 1)
  end

  def end_of_month
    Date.new(self.year, self.month, -1)
  end
end