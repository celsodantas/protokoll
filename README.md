# Protokoll [<img src="http://travis-ci.org/celsodantas/protokoll.png"/>](http://travis-ci.org/celsodantas]/protokoll)


## Description

Protokoll is a simple Rails 4 pluggin to simplify the management of a custom autoincrement value for a model. 

If you want to create an autoincrement information on the database, just like those callcenter registration number (2011000001, 2011000002, 20110000003 and on) this gem is for you! If you want to create just an custom autoincrement value, this gem is for you too! =)

All those tricky things to control like every month you have to reset the counter are gone! All you have to do is define a String column and let _Protokoll_ handle the rest:


```ruby
 # creating an autoincrement column based on Time
class Call < ActiveRecord::Base
    protokoll :registry_number  # by default it uses "%Y%m#####"
end

Time.local(2011)
call01 = Call.create
call01.registry_number
=> "201100001"

call02 = Call.create
call02.registry_number
=> "201100002"

Time.local(2012)

call03 = Call.create
call03.registry_number
=> "201200001"  # restarts counter because it is the first item of the year
```

If you want to use your own pattern, just do this:

```ruby
class Call < ActiveRecord::Base
    protokoll :registry_number, :pattern => "some#####thing"
end

# this will produce
call01 = Call.create
call01.registry_number
=> "some00001thing"

call02 = Call.create
call02.registry_number
=> "some00002thing"
```

Or use any time based format. You can use in the pattern any combination of:

```ruby
# assume it's 2011/01/01 12:00
"%Y" for year   	# => appends 2011 
"%y" for year   	# => appends 11 
"%m" for month  	# => appends 01
"%d" for day	 	# => appends 01
"%H" for hour	 	# => appends 12
"%M" for minute 	# => appends 00
"#"  for the autoincrement number (use and long as you want)
```

Using the Time formating string ("%y", "%m", ...) is totally optional. It's fine to use "CALL####", "BUY###N" or any combination you like.

Ex:
```ruby
# :number must be a String
class Car < ActiveRecord::Base
    protokoll :number, :pattern => "CAR%y#####"
end

# will produce => "CAR1100001", "CAR1100002"... 

# :sell_number must be a String
class House < ActiveRecord::Base
    protokoll :sell_number, :pattern => "%YHOUSE#####"
end

# will produce => "2011HOUSE00001", "2011HOUSE00002"...
```

## reserve_number!

   object.reserve_number!

Add a new intance method colled: "your_instance#reserve_#{column_name}!".
With it you can reserve a number without the need to save it to the database. Ex:

  car = Car.new
  car.number
  # => nil
  car.reserve_number!
  car.number
  # => "CAR1100001"
  # if you save it, the object will preserve the number: "CAR1100001"

It just increases the counter so any other object that gets saved or uses the #reserve_#{column_name} will get the next available number.

## Installation

Just add to the Gemfile:
 
```ruby
gem 'protokoll'
```

And run _bundle install_ on the Rails application folder

    bundle install

Run the generator

    rails g protokoll:migration

and migrate your database

    rake db:migrate


## Questions & Sugestions
This is my _first_ public gem, so if you have any questions os sugestions, feel free to contact me (use github msg system for that). It will be awesome to hear feedback to improve the code.

The gem is still on early _alpha_ so you may find bugs on it. And if you do, please use the _Issues_ here in Github and I'd love to fix it.  

This piece of software is free to use.

### Running tests in Development

You need to clone the project

    git clone git@github.com:celsodantas/protokoll.git
    cd protokoll

Then  prepare the test database:

    bundle
    cd test/dummy && rake db:migrate && rake db:test:prepare && cd ../..

Now run the rake test to run the tests:

    rake test
