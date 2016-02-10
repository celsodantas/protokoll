require 'active_record'

module Protokoll
  class Counter
    def self.next(object, options)
      element = Models::CustomAutoIncrement.find_or_create_by(build_attrs(object, options))

      element.counter = options[:start] if outdated?(element, options) || element.counter == 0
      element.counter += 1

      element.touch unless element.changed?
      element.save! if element.changed?

      element.save!

      Formater.new.format(element.counter, options)
    end

    private

    def self.build_attrs(object, options)
      attrs = {counter_model_name: object.class.to_s.underscore}
      return attrs unless options[:scope_by]

      scope_by =  options[:scope_by].respond_to?(:call) ?
                  object.instance_eval(&options[:scope_by]) :
                  object.send(options[:scope_by])

      attrs.merge(counter_model_scope: scope_by)
    end

    def self.outdated?(record, options)
      Time.now.utc.strftime(update_event(options)).to_i > record.updated_at.strftime(update_event(options)).to_i
    end

    def self.update_event(options)
      pattern = options[:pattern]
      event = String.new

      event += "%Y" if pattern.include? "%y" or pattern.include? "%Y"
      event += "%m" if pattern.include? "%m"
      event += "%H" if pattern.include? "%H"
      event += "%M" if pattern.include? "%M"
      event += "%d" if pattern.include? "%d"
      event
    end
  end
end
