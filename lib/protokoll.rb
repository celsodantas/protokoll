require "protokoll/auto_increment"
require "protokoll/extract_number"

module Protokoll
  extend ActiveSupport::Concern
  
  module ClassMethods
    @@protokoll = nil
    
    def protokoll
      @@protokoll
    end
    
    def protokoll(column = nil, _options = {})
      @@protokoll = AutoIncrement.new  if @@protokoll.nil?
      return @@protokoll if column.nil? 
      
      options = { :pattern => "%Y%m#####", :number_symbol => "#"}
      options.merge!(_options)

      @@protokoll.options = options          
    
      before_save do |record|      
        last = record.class.last
        
        if last.present?
          if @@protokoll.outdated?(last)
            @@protokoll.count = 0 
          else
            @@protokoll.count = ExtractNumber.number(last[column], options[:pattern]) 
          end
        end
        
        @@protokoll.count += 1
        record[column] = @@protokoll.next_custom_number(column, @@protokoll.count)
      end
    end
  end
  
end

ActiveRecord::Base.send :include, Protokoll