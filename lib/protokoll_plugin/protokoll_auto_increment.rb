module ProtokollPlugin

  class ProtokollAutoIncrement    
    attr_accessor :options
    
    def next_custom_number(column, number)
      prefix(options[:pattern]).to_s + 
      counter(options[:pattern], number).to_s + 
      sufix(options[:pattern]).to_s
    end
    
    def prefix(pattern)
      prefx = extract_prefix(pattern)
      expand_times(prefx.to_s)
    end
    
    def counter(pattern, n)
      format_counter(digits_size(pattern), n)
    end

    def sufix(pattern)
      sufx = extract_sufix(pattern)
      expand_times(sufx.to_s)
    end
    
    def format_counter(zeros, value)
      "%0#{zeros}d" % value
    end

    def extract_prefix(pattern)
      # Company#### => Company
      (pattern =~ /^(\s|\d)*[^#]+/ and $&)
    end

    def extract_sufix(pattern)
      # ###Company => Company
      (pattern =~ /[^#]+$/ and $&)
    end

    def expand_times(pattern)
      pattern.sub!("%y", Time.now.strftime("%y"))
      pattern.sub!("%Y", Time.now.strftime("%Y"))
      pattern.sub!("%d", Time.now.strftime("%d"))
      pattern.sub!("%m", Time.now.strftime("%m"))
      pattern.sub!("%M", Time.now.strftime("%M"))
      pattern.sub("%H", Time.now.strftime("%H"))
    end

    def digits_size(pattern)
      (pattern =~ /[#]+/ and $&).length
    end

    def time_outdated?(pattern, record_date)
      if (pattern.include? "%y") # year
        return true if Time.now.year > record_date.year
      end

      if (pattern.include? "%m") # month
        return true if Time.now.month > record_date.month
      end

      if (pattern.include? "%d") # day
        return true if Time.now.day > record_date.day
      end

      if (pattern.include? "%H") # hour
        return true if Time.now.hour > record_date.hour
      end

      if (pattern.include? "%M") # minute
        return true if Time.now.minute > record_date.min
      end
    end

    def outdated?(record)
      Time.now.strftime(update_event).to_i > record.created_at.strftime(update_event).to_i
    end

    def update_event
      pattern = options[:pattern]
      return "%M" if pattern.include? "%M"
      return "%H" if pattern.include? "%H"
      return "%m" if pattern.include? "%m"
      return "%y" if pattern.include? "%y" or pattern.include? "%Y"
      return ""
    end

  end
end