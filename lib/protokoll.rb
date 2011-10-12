require "protokoll/auto_increment"
require "protokoll/extract_number"
require "protokoll/class_variable"

module Protokoll
  extend ActiveSupport::Concern

  module ClassMethods
    
    # Class method available in models
    # 
    # == Example
    #   class Order < ActiveRecord::Base
    #      protokoll :number
    #   end
    #
    def protokoll(column = nil, _options = {})
      ClassVariable.add_to self, :@@protokoll, :default => AutoIncrement.new
      
      prot = ClassVariable.get_from self, :@@protokoll
      return prot if column.nil? 
      
      options = { :pattern => "%Y%m#####", :number_symbol => "#"}
      options.merge!(_options)
      
      prot.options = options          
          
      before_create do |record|      
        last = record.class.last
        
        if last.present?
          if prot.outdated?(last)
            prot.count = 0 
          else
            prot.count = ExtractNumber.number(last[column], options[:pattern]) 
          end
        end
        
        prot.count += 1
        record[column] = prot.next_custom_number(column, prot.count)
      end
    end
  end
  
end

ActiveRecord::Base.send :include, Protokoll