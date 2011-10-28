require 'test_helper'

class ProtokollTest < ActiveSupport::TestCase
  
  def setup
    time = Time.local(2011, 9, 25, 12, 0, 0)
    Timecop.travel(time)
    
    Protocol.destroy_all
    Protocol.protokoll.count = 0
  end
  
  test "using new number_symbol with default pattern should get 20110900001" do
     Protocol.protokoll.number_symbol = "$"
     Protocol.protokoll.pattern = "%Y%m$$$$$"
     
     protocol1 = Protocol.create
     assert_equal "20110900001", protocol1.number
   end
  
  test "first using # should get 1" do
    Protocol.protokoll.pattern = "#"
     
    protocol = Protocol.create
    assert_equal "1", protocol.number
  end
  
  test "second protocol on DB should have number should equals 2" do
    Protocol.protokoll.pattern = "#"
    
    Protocol.create
    protocol = Protocol.create
    assert_equal "2", protocol.number
  end
  
  test "third protocol on DB should have number should equals 3" do
    Protocol.protokoll.pattern = "#"
  
    protocol1 = Protocol.create
    protocol2 = Protocol.create
    protocol3 = Protocol.create
    assert_equal "3", protocol3.number
  end
    
  test "first using format A# should get A1" do
    Protocol.protokoll.pattern = "A#"
  
    protocol1 = Protocol.create
    assert_equal "A1", protocol1.number
  end
  
  test "second using format A# should get A2" do
    Protocol.protokoll.pattern = "A#"
  
    protocol1 = Protocol.create
    protocol2 = Protocol.create
    assert_equal "A2", protocol2.number
  end
  
  test "first using format A## should get A01" do
    Protocol.protokoll.pattern = "A##"
  
    protocol1 = Protocol.create
    assert_equal "A01", protocol1.number
  end
  
  test "second using format A## should get A02" do
    Protocol.protokoll.pattern = "A##"
  
    protocol1 = Protocol.create
    protocol2 = Protocol.create
    assert_equal "A02", protocol2.number
  end
  
  test "third using format A## should get A03" do
    Protocol.protokoll.pattern = "A##"
  
    protocol1 = Protocol.create
    protocol2 = Protocol.create
    protocol3 = Protocol.create
    assert_equal "A03", protocol3.number
  end
  
  test "first use of %y# should get 111" do
    Protocol.protokoll.pattern = "%y#"
  
    protocol1 = Protocol.create
    assert_equal "111", protocol1.number
  end
  
  test "second use of %y## should get 1101" do
    Protocol.protokoll.pattern = "%y##"
  
    protocol1 = Protocol.create
    assert_equal "1101", protocol1.number
    
    protocol2 = Protocol.create
    assert_equal "1102", protocol2.number
  end
  
  test "first use of %y%m## should get 110901" do
    Protocol.protokoll.pattern = "%y%m##"
  
    protocol1 = Protocol.create
    assert_equal "110901", protocol1.number
  end
   
   test "using %y%m## on next month after should get 111001" do
     Protocol.protokoll.pattern = "%y%m##"
   
     time = Time.local(2011, 9, 25, 12, 0, 0)
     Timecop.travel(time)
     
     Protocol.create
     Protocol.create

     Timecop.travel(Time.now + 1.month)

     protocol = Protocol.create
     assert_equal "111001", protocol.number
   end
   
   test "%y%m%H#### should get 1109120001" do
     Protocol.protokoll.pattern = "%y%m%H####"
 
     protocol1 = Protocol.create
 
     assert_equal "1109120001", protocol1.number
   end
 
   test "%y## on next year should get 1201" do
     Protocol.protokoll.pattern = "%y##"
 
     time = Time.local(2011, 9, 25, 12, 3, 0) # 2011
     protocol1 = Protocol.create
     time = Time.local(2012, 9, 25, 12, 3, 0) # 2012 - exactly 1 year after
     Timecop.travel(time)
 
     protocol2 = Protocol.create
 
     assert_equal "1201", protocol2.number
   end
 
   test "500.time create using %y%m%H#### should get 1109120500" do
     Protocol.protokoll.pattern = "%y%m%H####"
 
     500.times { Protocol.create }
 
     assert_equal "1109120500", Protocol.last.number
   end
 
   test "PROT%H%m%y#### should get PROT%H%m%y0001" do
     Protocol.protokoll.pattern = "PROT%H%m%y####"
 
     protocol1 = Protocol.create
 
     assert_equal "PROT1209110001", protocol1.number
   end
 
   test "PROT%Y%m%H#### should get PROT201109120001" do
     Protocol.protokoll.pattern = "PROT%Y%m%H####"
 
     protocol1 = Protocol.create
 
     assert_equal "PROT201109120001", protocol1.number
   end
 
   test "use of sufix ####PROTO should get 0001PROTO" do
     Protocol.protokoll.pattern = "####PROTO"
 
     protocol1 = Protocol.create
 
     assert_equal "0001PROTO", protocol1.number
   end
 
   test "use of sufix %Y%M####PROTO on 12:03 should get 2011030001PROTO" do
     Protocol.protokoll.pattern = "%Y%M####PROTO"
 
     time = Time.local(2011, 9, 25, 12, 3, 0)
     Timecop.travel(time)
 
     protocol1 = Protocol.create
 
     assert_equal "2011030001PROTO", protocol1.number
   end

  test "use of sufix %Y%M####PROTO on 12:15 should get 2011150001PROTO" do
    Protocol.protokoll.pattern = "%Y%M####PROTO"

    time = Time.local(2011, 9, 25, 12, 15, 0)
    Timecop.travel(time)

    protocol1 = Protocol.create

    assert_equal "2011150001PROTO", protocol1.number
  end

  test "using 2 models" do
    Protocol.protokoll.pattern = "%Y##"
    Call.protokoll.pattern = "%Y##"
  
    protocol = Protocol.create
    call = Call.create
    assert_equal "201101", protocol.number
    assert_equal "201101", call.number
  end

  test "updating model should not get a different number" do
    Protocol.protokoll.pattern = "%Y##"
  
    protocol = Protocol.new

    protocol.save
    assert_equal "201101", protocol.number
  
    protocol.save
    assert_equal "201101", protocol.number
  end

  # test "reserve_number should set number to instance" do
  #   Protocol.protokoll.pattern = "%Y##"
  # 
  #   protocol = Protocol.new
  #   protocol.reserve_number!
  # 
  #   assert_equal "201101", protocol.number
  #   protocol.save
  #   assert_equal "201101", protocol.number
  # 
  #   protocol = Protocol.new
  #   protocol.save
  #   assert_equal "201102", protocol.number
  # end
  # 
  # test "reserve_number should assure number if reserved" do
  #   Protocol.protokoll.pattern = "%Y##"
  # 
  #   protocol1 = Protocol.new
  #   protocol1.reserve_number!
  # 
  #   protocol2 = Protocol.new
  #   protocol2.save
  # 
  #   assert_equal "201101", protocol1.number
  #   assert_equal "201102", protocol2.number
  # end
  # 
  # test "reserve_number should assure number if reserved if next month" do
  #    Protocol.protokoll.pattern = "%Y%m##"
  # 
  #    protocol1 = Protocol.create
  #    protocol1.reserve_number!
  # 
  #    Timecop.travel(Time.now + 1.month)
  #    
  #    protocol2 = Protocol.new
  #    protocol2.save!
  # 
  #    assert_equal "20110901", protocol1.number
  #    assert_equal "20111001", protocol2.number
  #  end
  
  ## Can't reproduce this on test environmet!
  ## if you know how to do that, contact-me!
  # test "Start application with populated db." do  
  #   Protocol.protokoll.pattern = "%Y%M####PROTO"
  # 
  #   Protocol.create
  #   Protocol.create
  #   Protocol.create
  #   
  #   # restart application or reload Protocol model
  #   # how do I do that? 
  #
  #   protocol = Protocol.create
  # 
  #   assert_equal "2011090004PROTO", protocol.number
  # end
end


