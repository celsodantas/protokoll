module Protokoll
  module ClassVariable
    def self.add_to(klass, instance, options = nil)
      if not klass.class_variables.include? instance
        klass.class_variable_set instance, options[:default]
      end
    end
    
    def self.get_from(klass, instance)
      klass.class_variable_get(instance)
    end
  end
end