module ProtocolNumberPlugin
  
  extend ActiveSupport::Concern
  
  include do
  end
  
  def format_number(zeros, value)
    "%0#{zeros}d" % value
  end
  
  def prefix(format)
    format = format[0, format.size - leading_zeros_size(format)]
    expand_times(format)
  end
  
  def expand_times(format)
    format.sub!("%y", Time.now.strftime("%y"))
    format.sub!("%Y", Time.now.strftime("%Y"))
    
    format.sub!("%d", Time.now.strftime("%d"))
    
    format.sub!("%m", Time.now.strftime("%m"))
    format.sub!("%M", Time.now.strftime("%M"))
    
    format.sub!("%H", Time.now.strftime("%H"))
    
    format
  end
  
  def prefix_size(format)
    prefix(format).size
  end
  
  def leading_zeros_size(format)
    (format.scan /[#]+$/)[0].length
  end
  
  def create_number_mask(format)
    format.split("").map do |i|
      (i == "#") ? 1 : 0
    end
  end
  
  def extract_using_mask(db_number, mask)
    result = ""
    db_number.split("").each_with_index do |n, i| 
      result += n if mask[i] == 1
    end
    result.to_i
  end
  
  def final(format, number)
    prefix(format) + format_number(leading_zeros_size(format), number)
  end
  
  def extract_number(number, format)
    mask = create_number_mask(format)
    extract_using_mask(number, mask)
  end
  
  def create_year_mask(format)
    format.sub!("%y", "^^")
    format.sub!("%Y", "^^^^")
    format.split("").map do |i|
      (i == "^") ? 1 : 0
    end
  end
  
  def extract_year(number, format)
    mask = create_year_mask(format)
    extract_using_mask(number, mask)
  end
  
  def now(format)
    return Time.now.strftime("%y") if format.include? "%y"
    return Time.now.strftime("%Y") if format.include? "%Y"
  end
  
  module ClassMethods
    def protocol_number(column, _options = {})
      options = { :format => "######", :number_symbol => "#"}
      options.merge!(_options)
    
      before_create do |record|
        format = options[:format].first.number_format
        
        last = self.class.last
        if last == nil
          record[column] = final(format, 1)
        else
          year = extract_year(last.number, format)
          if not year.zero? and now(format) > year
            record[column] = final(format, 1)
          end
          
          number = extract_number(last.number, format)
          number += 1
          
          record[column] = final(format, number)
        end
      end
    end
  end
  
end

ActiveRecord::Base.send :include, ProtocolNumberPlugin