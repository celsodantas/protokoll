module ProtokollPlugin
  extend ActiveSupport::Concern

  def format_counter(zeros, value)
    "%0#{zeros}d" % value
  end
  
  def extract_prefix(pattern)
    # Company#### => Company
    (pattern =~ /^(\s|\d|#)*[^#]+/ and $&)
  end
  
  def extract_sufix(pattern)
    # ###Company => Company
    (pattern =~ /[^#]+$/ and $&)
  end
  
  def prefix(pattern)
    prefx = extract_prefix(pattern)
    expand_times(prefx.to_s)
  end
  
  def sufix(pattern)
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
  
  def counter(pattern, n)
    format_counter(digits_size(pattern), n)
  end
  
  def time_outdated?(pattern, record_date)
    if (pattern.include? "%y") #year
      return true if Time.now.year > record_date.year
    end
    
    if (pattern.include? "%m") # month
      return true if Time.now.month > record_date.month
    end
    
    if (pattern.include? "%d") # day
      return true if Time.now.day > record_date.day
    end
    
    if (pattern.include? "%h") # hour
      return true if Time.now.hour > record_date.hour
    end
    
    if (pattern.include? "%M") # minute
      return true if Time.now.hour > record_date.min
    end
    
    if (pattern.include? "%s") # minute
      return true if Time.now.hour > record_date.sec
    end
  end
  
  module ClassMethods
    @@protokoll_count = 0
    
    def protokoll_count=(p)
      @@protokoll_count = p
    end
    
    def protokoll_count
      @@protokoll_count
    end
    
    def protokoll(column, _options = {})
      options = { :pattern => "######", :number_symbol => "#"}
      options.merge!(_options)
    
      before_create do |record|
        pattern = options[:pattern].first.number_format
        
        @@protokoll_count += 1
        record[column] = prefix(pattern).to_s + 
                         counter(pattern, @@protokoll_count).to_s + 
                         sufix(pattern).to_s
      end

    end
  end
  
end

ActiveRecord::Base.send :include, ProtokollPlugin