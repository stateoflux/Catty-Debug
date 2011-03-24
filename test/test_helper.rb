ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

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
      r2d2.tx_memories << tx_memories("tx_memory_#{i}".to_sym)
      r2d2.rx_memories << rx_memories("rx_memory_#{i}".to_sym)
    end
  end

  def login_as(user)
    @request.session[:user_id] = users(user).id
  end
end
