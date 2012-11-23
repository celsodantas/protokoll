class Call < ActiveRecord::Base
  attr_accessible :registry_number

  protokoll :registry_number
end
