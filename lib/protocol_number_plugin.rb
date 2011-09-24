module ProtocolNumberPlugin
  
  extend ActiveSupport::Concern
  
  include do
  end
  
  def format_number(zeros, value)
    "%0#{zeros}d" % value
  end
  
  def head(format)
    format[0, format.size - leading_zeros_size(format)]
  end
  
  def head_size(format)
    head(format).size
  end
  
  def leading_zeros_size(format)
    # Using # as a number symbol
    # Getting number right #'s in :format
    # ex: "##"  => 2
    #     "X#"  => 1
    #     "#X#" => 1
    (format.scan /[#]+$/)[0].length
  end
  
  module ClassMethods
    def protocol_number(column, _options = {})
      options = { :format => "######", :number_symbol => "#"}
      options.merge!(_options)
      
      # Used in Test only
      # remove line above when plugin finished
      before_create do |record|
        format = options[:format].first.number_format
        
        last = self.class.last
        if last == nil
          record[column] = head(format) + format_number(leading_zeros_size(format), 1)
        else
          last.number
          
          record[column] = (last.number.to_i + 1).to_s
        end
      end
    end
  end
  
end


ActiveRecord::Base.send :include, ProtocolNumberPlugin