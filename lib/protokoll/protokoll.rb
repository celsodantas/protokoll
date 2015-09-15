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
      raise ArgumentError.new('Protokoll pattern is nil, check your configuration.') if options[:pattern].nil?
      raise ArgumentError.new('Protokoll pattern needs at least one counter symbol, check your configuration.') unless pattern_includes_symbols?(options)

      # Defining custom method
      send :define_method, "reserve_#{options[:column]}!".to_sym do
        self[column] = Counter.next(self, options)
      end

      # Signing before_create
      before_create do |record|
        unless record[column].present?
          record[column] = Counter.next(self, options)
        end
      end
    end

    private

    def pattern_includes_symbols?(options)
      options[:pattern].count(options[:number_symbol]) > 0
    end
  end

end
