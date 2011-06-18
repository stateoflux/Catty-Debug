ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  #fixtures :all

=begin
  # Add more helper methods to be used by all tests here...
  def build_assembly
    assembly = assemblies(:ringar_3)
    add_r2d2s(assembly)
    return assembly
  end
  def add_r2d2s(assembly)
   # Assembly has many R2D2s and each R2D2 has many tx & rx memories
    0.upto(assembly.num_of_r2d2s - 1) do |i|
      r2d2 = r2d2s("r2d2_#{i}".to_sym)
      add_memories(r2d2)
      assembly.r2d2s << r2d2
    end
  end

  def add_memories(r2d2)
    4.times do |i|
      puts "inside add memory loop"
      r2d2.tx_memories << Factory.build(:tx_memory)
      r2d2.rx_memories << Factory.build(:rx_memory)
      #r2d2.tx_memories << tx_memories("tx_memory_#{i}".to_sym)
      #r2d2.rx_memories << rx_memories("rx_memory_#{i}".to_sym)
    end
  end
=end

  def login_as(user)
    @request.session[:user_id] = user.id
    # @request.session[:user_id] = users(user).id #fixture version
  end

  def build_mikki
    Factory(:user, :first_name => "mikki", :last_name => "baird-rosecrans",
                    :email => "mikki@cisco.com", :admin => false)
  end

  def test_result_dump
  "C2LCP2>3% resu -tr2d2_7\r\n Test Description    :  {R2D2RXPB} -> R2D2_7\r\n Time Of Run         : 2011/06/08 21:20:03\r\n Error Code          :         26\r\n Start Address       : 0x00000000\r\n End Address         : 0x007FFFFF\r\n Data Pattern        :       0x55\r\n Device Number       :          1\r\n Type of Test        :       BIST\r\n Mode Type           :     Normal\r\n Write timeout       :  0x0200\r\n Read timeout        :  0x0200\r\n Access Type         : BurstWriteRead\r\n Run Count           :          1\r\n Test Fail Count     :          1\r\n Error Count         :          1\r\n Fail Address        : 0x00004002\r\n Data Expected       : 0x 5555 5555 5555 5555 5555 5555 5555 5555 5555 5555 5555 \r\n                          5555 5555 5555 5555 5555 5555 5555 5555 5555 5555 5555 \r\n                          5555 5555 5555 5555 5555 5555 5555 5555 5555 5555 5555 \r\n                          5555 5555 5555 \r\n Data Read           : 0x 5555 5555 5555 5555 5555 5555 5555 5555 5555 55d5 5575 \r\n                          5555 5555 5555 5555 5555 5555 5555 5555 5555 5555 5555 \r\n                          5555 5555 5555 5555 5555 55d5 5575 5555 5555 5555 5555 \r\n                          5555 5555 5555 \r\n Error Message       : DATA_COMPARE_ERROR\r\n Elapsed Time (msec) :      17042\r\n"
  end
end
