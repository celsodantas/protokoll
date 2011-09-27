require "protokoll_plugin/protokoll_auto_increment"
require "protokoll_plugin/extract_number"

module ProtokollPlugin
  extend ActiveSupport::Concern
  
  module ClassMethods
    @@protokoll_count = 0
    @@protokoll_auto_increment

    def protokoll_count=(p)
      @@protokoll_count = p
    end
    
    def protokoll_count
      @@protokoll_count
    end
    
    def protokoll_pattern=(p)
      @@protokoll_auto_increment.options[:pattern] = p
    end
    
    def protokoll_pattern
      @@protokoll_auto_increment.options[:pattern]
    end
    
    def protokoll(column, _options = {})
      options = { :pattern => "%Y%m#####", :number_symbol => "#"}
      options.merge!(_options)

      before_save do |record|      
        @@protokoll_auto_increment = ProtokollAutoIncrement.new
        @@protokoll_auto_increment.options = options

        last = record.class.last
        
        if last.present?
          if @@protokoll_auto_increment.outdated?(last)
            @@protokoll_count = 0 
          else
            @@protokoll_count = ExtractNumber.number(last[column], options[:pattern]) 
          end
        end
        
        @@protokoll_count += 1
        record[column] = @@protokoll_auto_increment.next_custom_number(column, @@protokoll_count)
      end
    end
  end
  
end

ActiveRecord::Base.send :include, ProtokollPlugin