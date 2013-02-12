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
    def protokoll(column, _options = {})
      options = { :pattern       => "%Y%m#####", 
                  :number_symbol => "#",
                  :column        => column,
                  :start         => 0 }

      options.merge!(_options)
      
      # Defining custom method
      send :define_method, "reserve_#{options[:column]}!".to_sym do
        self[column] = Counter.next(self, options)
      end

      # Signing before_create
      before_create do |record|
        return if record[column].present?

        record[column] = Counter.next(self, options)
      end
    end
  end
  
end
