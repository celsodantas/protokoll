require 'test_helper'

class ProtokollTest < ActiveSupport::TestCase

  def setup
    time = Time.local(2011, 9, 25, 12, 0, 0)
    Timecop.travel(time)
  end

  def teardown
    reset_models
  end

  def reset_models
    ProtokollTest.send(:remove_const, 'Protocol') if defined? Protocol
    ProtokollTest.send(:remove_const, 'Call')     if defined? Call
  end

  ##
  # Tests
  ##

  test "using new number_symbol with default pattern should get 20110900001" do
    class Protocol < ActiveRecord::Base
      protokoll :number, :pattern => "%Y%m$$$$$", :number_symbol => "$"
    end

    protocol = Protocol.create
    assert_equal "20110900001", protocol.number
  end

  test "should get 20110900001 (format number %Y%m#####)" do
    class Protocol < ActiveRecord::Base
      protokoll :number
    end

    protocol = Protocol.create
    assert_equal "20110900001", protocol.number
  end

  test "should get 20110900002 for second save (format number %Y%m#####)" do
    class Protocol < ActiveRecord::Base
      protokoll :number
    end

    protocol1 = Protocol.create
    protocol2 = Protocol.create

    assert_equal "20110900002", protocol2.number
  end

  test "should get 201100002 for second save (format number %Y#####)" do
    class Protocol < ActiveRecord::Base
      protokoll :number, :pattern => "%Y#####"
    end

    protocol = Protocol.create

    assert_equal "201100001", protocol.number
  end

  test "second protocol on DB should have number should equals 1" do
    class Protocol < ActiveRecord::Base
      protokoll :number, :pattern => "#"
    end

    protocol = Protocol.create
    assert_equal "1", protocol.number
  end

  test "third protocol on DB should have number should equals 3" do
    class Protocol < ActiveRecord::Base
      protokoll :number, :pattern => "#"
    end

    Protocol.new.save
    Protocol.new.save
    protocol3 = Protocol.new
    protocol3.save

    assert_equal "3", protocol3.number
  end

  test "first using format A# should get A1" do
    class Protocol < ActiveRecord::Base
      protokoll :number, :pattern => "A#"
    end

    protocol1 = Protocol.new
    protocol1.save

    assert_equal "A1", protocol1.number
  end

  test "first using format A## should get A01" do
    class Protocol < ActiveRecord::Base
      protokoll :number, :pattern => "A##"
    end

    protocol1 = Protocol.create
    assert_equal "A01", protocol1.number
  end

  test "second using format A## should get A02" do
    class Protocol < ActiveRecord::Base
      protokoll :number, :pattern => "A##"
    end

    protocol1 = Protocol.create
    protocol2 = Protocol.create
    assert_equal "A02", protocol2.number
  end

  test "third using format A## should get A03" do
    class Protocol < ActiveRecord::Base
      protokoll :number, :pattern => "A##"
    end

    protocol1 = Protocol.create
    protocol2 = Protocol.create
    protocol3 = Protocol.create
    assert_equal "A03", protocol3.number
  end

  test "first use of %y# should get 111" do
    class Protocol < ActiveRecord::Base
      protokoll :number, :pattern => "%y#"
    end

    protocol1 = Protocol.create
    assert_equal "111", protocol1.number
  end


  test "first use of %y%m## should get 110901" do
    class Protocol < ActiveRecord::Base
      protokoll :number, :pattern => "%y%m##"
    end

    protocol1 = Protocol.create
    assert_equal "110901", protocol1.number
  end

  test "using %y%m## on next month after should get 111001" do
    class Protocol < ActiveRecord::Base
      protokoll :number, :pattern => "%y%m##"
    end

    time = Time.local(2011, 9, 25, 12, 0, 0)
    Timecop.travel(time)

    Protocol.create
    Protocol.create

    Timecop.travel(Time.now + 1.month)

    protocol = Protocol.create
    assert_equal "111001", protocol.number
  end

   test "%y%m%H#### should get 1109120001" do
     class Protocol < ActiveRecord::Base
       protokoll :number, :pattern => "%y%m%H####"
     end

     protocol1 = Protocol.create

     assert_equal "1109120001", protocol1.number
   end

   test "%y## on next year should get 1201" do
    class Protocol < ActiveRecord::Base
      protokoll :number, :pattern => "%y##"
    end

    time = Time.local(2011, 9, 25, 12, 3, 0) # 2011
    protocol1 = Protocol.create
    time = Time.local(2012, 9, 25, 12, 3, 0) # 2012 - exactly 1 year after
    Timecop.travel(time)

    protocol2 = Protocol.create

    assert_equal "1201", protocol2.number
   end

  test "500.time create using %y%m%H#### should get 1109120500" do
    class Protocol < ActiveRecord::Base
      protokoll :number, :pattern => "%y%m%H####"
    end

    500.times { Protocol.create }

    assert_equal "1109120500", Protocol.last.number
  end

  test "PROT%H%m%y#### should get PROT%H%m%y0001" do
    class Protocol < ActiveRecord::Base
      protokoll :number, :pattern => "PROT%H%m%y####"
    end

    protocol1 = Protocol.create

    assert_equal "PROT1209110001", protocol1.number
  end

  test "PROT%Y%m%H#### should get PROT201109120001" do
    class Protocol < ActiveRecord::Base
      protokoll :number, :pattern => "PROT%Y%m%H####"
    end

    protocol1 = Protocol.create

    assert_equal "PROT201109120001", protocol1.number
  end

  test "use of sufix ####PROTO should get 0001PROTO" do
    class Protocol < ActiveRecord::Base
      protokoll :number, :pattern => "####PROTO"
    end

    protocol1 = Protocol.create

    assert_equal "0001PROTO", protocol1.number
  end

  test "use of sufix %Y%M####PROTO on 12:03 should get 2011030001PROTO" do
    class Protocol < ActiveRecord::Base
      protokoll :number, :pattern => "%Y%M####PROTO"
    end

    time = Time.local(2011, 9, 25, 12, 3, 0)
    Timecop.travel(time)

    protocol1 = Protocol.create

    assert_equal "2011030001PROTO", protocol1.number
  end

  test "use of sufix %Y%M####PROTO on 12:15 should get 2011150001PROTO" do
    class Protocol < ActiveRecord::Base
      protokoll :number, :pattern => "%Y%M####PROTO"
    end

    time = Time.local(2011, 9, 25, 12, 15, 0)
    Timecop.travel(time)

    protocol1 = Protocol.create

    assert_equal "2011150001PROTO", protocol1.number
  end

  test "using 2 models" do
    class Protocol < ActiveRecord::Base
      protokoll :number, :pattern => "%Y##"
    end

    class Call < ActiveRecord::Base
      protokoll :number, :pattern => "%Y##"
    end

    protocol = Protocol.create
    call = Call.create
    assert_equal "201101", protocol.number
    assert_equal "201101", call.number
  end

  test "using 2 models with different patterns" do
    class Protocol < ActiveRecord::Base
      protokoll :number, :pattern => "%YA#"
    end

    class Call < ActiveRecord::Base
      protokoll :number, :pattern => "%YB#"
    end

    protocol = Protocol.create
    call = Call.create
    assert_equal "2011A1", protocol.number
    assert_equal "2011B1", call.number
  end

  test "updating model should not get a different number" do
    class Protocol < ActiveRecord::Base
      protokoll :number, :pattern => "%Y##"
    end

    protocol = Protocol.new

    protocol.save
    assert_equal "201101", protocol.number

    protocol.save
    assert_equal "201101", protocol.number
  end

  test "reserve_number should set number to instance" do
    class Protocol < ActiveRecord::Base
      protokoll :number, :pattern => "%Y##"
    end

    protocol = Protocol.new
    protocol.reserve_number!

    assert_equal "201101", protocol.number
    protocol.save
    assert_equal "201101", protocol.number

    protocol = Protocol.new
    protocol.save
    assert_equal "201102", protocol.number
  end

  test "reserve_number should assure number if reserved" do
    class Protocol < ActiveRecord::Base
      protokoll :number, :pattern => "%Y##"
    end

    protocol1 = Protocol.new
    protocol1.reserve_number!

    protocol2 = Protocol.new
    protocol2.save

    assert_equal "201101", protocol1.number
    assert_equal "201102", protocol2.number
  end

  test "reserve_number should assure number if reserved if next month" do
    class Protocol < ActiveRecord::Base
      protokoll :number, :pattern => "%Y%m##"
    end

    protocol1 = Protocol.new
    protocol1.reserve_number!

    Timecop.travel(Time.now + 1.month)

    protocol2 = Protocol.new
    protocol2.save!

    assert_equal "20110901", protocol1.number
    assert_equal "20111001", protocol2.number
   end

  test "starting shift should work" do
    class Protocol < ActiveRecord::Base
      protokoll :number, :pattern => "%Y%m##", :start => 33
    end

    protocol = Protocol.new
    protocol.save

    assert_equal "20110934", protocol.number
  end

  test "counter should not be reset after first reset call while in the non reset window" do
    class Protocol < ActiveRecord::Base
      protokoll :number, :pattern => "%Y%m##"
    end

    protocol1 = Protocol.create

    Timecop.travel(Time.now + 1.month)
    protocol2 = Protocol.create

    Timecop.travel(2.day)
    protocol3 = Protocol.create

    assert_equal "20110901", protocol1.number
    assert_equal "20111001", protocol2.number
    assert_equal "20111002", protocol3.number
  end

  test "counter should consider day in pattern" do
    class Protocol < ActiveRecord::Base
      protokoll :number, :pattern => "%Y%m%d##"
    end

    protocol1 = Protocol.create!
    protocol2 = Protocol.create!

    Timecop.travel(1.day)

    protocol3 = Protocol.create!

    assert_equal "2011092501", protocol1.number
    assert_equal "2011092502", protocol2.number
    assert_equal "2011092601", protocol3.number
  end

  test "rejects empty patterns" do

    assert_raise ArgumentError do
      class Protocol < ActiveRecord::Base
        protokoll :number, :pattern => nil
      end
    end
  end

  test "rejects invalid patterns" do

    assert_raise ArgumentError do
      class Protocol < ActiveRecord::Base
        protokoll :number, :pattern => "%ydodgyPattern"
      end
    end
  end

end


