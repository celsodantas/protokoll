require 'test_helper'

class ProtocolNumberPluginTest < ActiveSupport::TestCase
  
  def setup
    time = Time.local(2011, 1, 25, 12, 0, 0)
    Timecop.travel(time)
    load "dummy/db/seeds.rb"
  end
  
  test "first protocol on DB should have number should equals 1" do
    Principal.first.number_format = "#"
    protocol = Protocol.create
    assert_equal "1", protocol.number
  end
  
  test "second protocol on DB should have number should equals 2" do
    Principal.first.number_format = "#"
    protocol1 = Protocol.create
    protocol2 = Protocol.create
    assert_equal "2", protocol2.number
  end

  test "third protocol on DB should have number should equals 3" do
    Principal.first.number_format = "#"
    protocol1 = Protocol.create
    protocol2 = Protocol.create
    protocol3 = Protocol.create
    assert_equal "3", protocol3.number
  end

  test "first using format A# should get A1" do
    principal = Principal.first
    principal.number_format = "A#"
    principal.save

    protocol1 = Protocol.create
    assert_equal "A1", protocol1.number
  end

  test "second using format A# should get A2" do
    principal = Principal.first
    principal.number_format = "A#"
    principal.save

    protocol1 = Protocol.create
    protocol2 = Protocol.create
    assert_equal "A2", protocol2.number
  end

  test "first using format A## should get A01" do
    principal = Principal.first
    principal.number_format = "A##"
    principal.save

    protocol1 = Protocol.create
    assert_equal "A01", protocol1.number
  end
  
  test "second using format A## should get A02" do
    principal = Principal.first
    principal.number_format = "A##"
    principal.save

    protocol1 = Protocol.create
    protocol2 = Protocol.create
    assert_equal "A02", protocol2.number
  end
  
  test "third using format A## should get A03" do
    principal = Principal.first
    principal.number_format = "A##"
    principal.save

    protocol1 = Protocol.create
    protocol2 = Protocol.create
    protocol3 = Protocol.create
    assert_equal "A03", protocol3.number
  end
  
  test "first use of %y# should get 111" do
    principal = Principal.first
    principal.number_format = "%y#"
    principal.save

    protocol1 = Protocol.create
    assert_equal "111", protocol1.number
  end
  
  test "second use of %y## should get 1101" do
    principal = Principal.first
    principal.number_format = "%y##"
    principal.save

    protocol1 = Protocol.create
    assert_equal "1101", protocol1.number
  end
  
  test "first use of %y%m## should get 110901" do
    principal = Principal.first
    principal.number_format = "%y%m##"
    principal.save

    protocol1 = Protocol.create
    assert_equal "110901", protocol1.number
  end
  
  test "second use of %y%m## on next month after should get 111001" do
    principal = Principal.first
    principal.number_format = "%y%m##"
    principal.save

    protocol1 = Protocol.create
    
    Timecop.travel(Time.now.month + 1.month)
    
    protocol2 = Protocol.create
    
    assert_equal "111001", protocol2.number
  end
end


