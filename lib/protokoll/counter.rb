require 'active_record'

module Protokoll
  class Counter
    def self.next(object, options)
      element = Models::CustomAutoIncrement.find_or_create_by_model_name(object.class.to_s.underscore)

      element.counter = options[:start] if outdated?(element, options) || element.counter == 0
      element.counter += 1

      element.save!

      Formater.new.format(element.counter, options)
    end

    private

    def self.outdated?(record, options)
      Time.now.strftime(update_event(options)).to_i > record.created_at.strftime(update_event(options)).to_i
    end

    def self.update_event(options)
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
