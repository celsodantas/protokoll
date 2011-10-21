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
      #
      # TODO:: REFACTOR THE CODE!
      #
      ClassVariable.add_to self, :@@protokoll, :default => AutoIncrement.new
      
      prot = ClassVariable.get_from self, :@@protokoll
      return prot if column.nil? 
      
      options = { :pattern => "%Y%m#####", :number_symbol => "#", :column => column }
      options.merge!(_options)
      
      prot.options = options

      send :define_method, "reserve_#{prot.options[:column]}!".to_sym do
        prot = self.class.protokoll
        column_name = prot.options[:column]
        self[column_name] = prot.next_custom_number(prot.count)
      end
      
      before_create do |record|
        return if record[column].present?
        
        if prot.last.present?
          last_at = prot.last[:at]
          number = prot.last[:number]
        elsif record.class.last.present?
          last_at = record.class.last.created_at
          number = record.class.last[:column]
        end
        
        if last_at.present?
          if prot.outdated?(last_at)
            prot.count = 0 
          else
            prot.count = ExtractNumber.number(number, options[:pattern]) 
          end
        end
      
        record[column] = prot.next_custom_number(prot.count)
      end
    end
  end
end

ActiveRecord::Base.send :include, Protokoll