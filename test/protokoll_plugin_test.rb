require 'test_helper'

class ProtokollPluginTest < ActiveSupport::TestCase
  
  def setup
    time = Time.local(2011, 9, 25, 12, 0, 0)
    Timecop.travel(time)
    
    Protocol.protokoll_count = 0
  end
  
  test "first protocol on DB should have number should equals 1" do
    Principal.create!(:number_format => "#")

    protocol = Protocol.create
    assert_equal "1", protocol.number
  end
  
  test "second protocol on DB should have number should equals 2" do
    Principal.create!(:number_format => "#")
    
    protocol1 = Protocol.create
    protocol2 = Protocol.create
    assert_equal "2", protocol2.number
  end
  
  test "third protocol on DB should have number should equals 3" do
    Principal.create!(:number_format => "#")
    
    protocol1 = Protocol.create
    protocol2 = Protocol.create
    protocol3 = Protocol.create
    assert_equal "3", protocol3.number
  end
  
  test "first using format A# should get A1" do
    Principal.create!(:number_format => "A#")
  
    protocol1 = Protocol.create
    assert_equal "A1", protocol1.number
  end
  
  test "second using format A# should get A2" do
    Principal.create!(:number_format => "A#")
  
    protocol1 = Protocol.create
    protocol2 = Protocol.create
    assert_equal "A2", protocol2.number
  end

  test "first using format A## should get A01" do
    Principal.create!(:number_format => "A##")
  
    protocol1 = Protocol.create
    assert_equal "A01", protocol1.number
  end
  
  test "second using format A## should get A02" do
    Principal.create!(:number_format => "A##")
  
    protocol1 = Protocol.create
    protocol2 = Protocol.create
    assert_equal "A02", protocol2.number
  end
  
  test "third using format A## should get A03" do
    Principal.create!(:number_format => "A##")
  
    protocol1 = Protocol.create
    protocol2 = Protocol.create
    protocol3 = Protocol.create
    assert_equal "A03", protocol3.number
  end
  
  test "first use of %y# should get 111" do
    Principal.create!(:number_format => "%y#")
  
    protocol1 = Protocol.create
    assert_equal "111", protocol1.number
  end
  
  test "second use of %y## should get 1101" do
    Principal.create!(:number_format => "%y##")
  
    protocol1 = Protocol.create
    assert_equal "1101", protocol1.number
  end
  
  test "first use of %y%m## should get 110901" do
    Principal.create!(:number_format => "%y%m##")
  
    protocol1 = Protocol.create
    assert_equal "110901", protocol1.number
  end
  
  test "second use of %y%m## on next month after should get 111001" do
    Principal.create!(:number_format => "%y%m##")
  
    protocol1 = Protocol.create
    
    Timecop.travel(Time.now + 1.month)
    
    protocol2 = Protocol.create
    
    assert_equal "111002", protocol2.number
  end
end


