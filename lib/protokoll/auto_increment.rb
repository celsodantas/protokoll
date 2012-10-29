module Protokoll

  class AutoIncrement    
    attr_accessor :options
    attr_accessor :count
    
    def initialize
      @count = 0
    end
    
    def pattern=(p)
      options[:pattern] = p
    end
    
    def pattern
      options[:pattern]
    end
    
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

    def outdated?(record)
      Time.now.strftime(update_event).to_i > record.created_at.strftime(update_event).to_i
    end

    # BUG 1 : If using %y%m# and only year changes (user stays 
    # more then one year without updating the model) counter doesn't updates!
    def update_event
      pattern = options[:pattern]
      event = String.new
      
      event += "%Y" if pattern.include? "%y" or pattern.include? "%Y"
      event += "%m" if pattern.include? "%m"
      event += "%H" if pattern.include? "%H"
      event += "%M" if pattern.include? "%M"
      event
    end

  end
end