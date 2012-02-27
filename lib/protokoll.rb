require "protokoll/models/custom_auto_increment"
require "protokoll/formater"
require "protokoll/counter"
require "protokoll/protokoll"

ActiveRecord::Base.send :include, Protokoll