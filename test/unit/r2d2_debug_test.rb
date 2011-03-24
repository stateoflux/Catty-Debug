require 'test_helper'

class R2d2DebugTest < ActiveSupport::TestCase
  # CRUD TESTING
  test "should create r2d2_debug" do
    r2d2_debug = R2d2Debug.new
    r2d2_debug.user = users(:mikki) 

    # build a valid assembly from fixtures
    r2d2_debug.assembly = build_assembly 
    r2d2_debug.bad_bits << bad_bits(:one) 
    r2d2_debug.bad_bits << bad_bits(:fifty) 
    r2d2_debug.bad_bits << bad_bits(:one_hundred) 
    r2d2_debug.rework_request = rework_requests(:rework_1)
    r2d2_debug.serial_number = 'SAD111111WM'
    r2d2_debug.r2d2_instance = 0
    r2d2_debug.interface = "Rx" 

    assert r2d2_debug.save
  end

  test "should find r2d2_debug" do
    r2d2_debug_id = r2d2_debugs(:wayne_debug).id
    
    # assert that no exception is raised when a find is executed on the 
    # R2d2Debug class...tests that read operation is working
    assert_nothing_raised { R2d2Debug.find(r2d2_debug_id) }
  end

  test "should update r2d2_debug" do
    # find the r2d2_debug that was created above

    assert R2d2Debug.update_all(:r2d2_instance => 7, :serial_number => 'SAD111111W')
  end

  test "should destroy r2d2_debug" do
    r2d2_debug = r2d2_debugs(:mikki_debug)

    r2d2_debug.destroy
    # assert that find method will cause a RecordNotFound exception since this record should have been deleted.
    assert_raise(ActiveRecord::RecordNotFound) { R2d2Debug.find(r2d2_debug.id) } 
  end

# VALIDATION TESTING
  test "should not create a r2d2_debug without any of its attributes or associations" do
    r2d2_debug = R2d2Debug.new

    assert !r2d2_debug.valid?  
    assert r2d2_debug.errors[:user].any?
    assert r2d2_debug.errors[:assembly].any?
    assert r2d2_debug.errors[:r2d2_instance].any?
    assert r2d2_debug.errors[:interface].any?
    assert r2d2_debug.errors[:bad_bits].any?
    assert r2d2_debug.errors[:serial_number].any?
    assert_equal "can't be blank", r2d2_debug.errors[:user][0]
    assert_equal "can't be blank", r2d2_debug.errors[:assembly][0]
    assert_equal "can't be blank", r2d2_debug.errors[:r2d2_instance][0]
    assert_equal "can't be blank", r2d2_debug.errors[:interface][0]
    assert_equal "can't be blank", r2d2_debug.errors[:bad_bits][0]
    assert_equal "can't be blank", r2d2_debug.errors[:serial_number][0]
    assert !r2d2_debug.save
  end

  test "should not create a r2d2_debug if r2d2_instance is not a number" do
    r2d2_debug = R2d2Debug.new
    r2d2_debug.r2d2_instance = "one"

    assert !r2d2_debug.valid?  
    assert r2d2_debug.errors[:r2d2_instance].any?
    assert_equal "is not a number", r2d2_debug.errors[:r2d2_instance][0]
    assert !r2d2_debug.save
  end

  test "should not create a r2d2_debug if r2d2_instance is not an integer" do
    r2d2_debug = R2d2Debug.new
    r2d2_debug.r2d2_instance = 5.0 

    assert !r2d2_debug.valid?  
    assert r2d2_debug.errors[:r2d2_instance].any?
    assert_equal "must be an integer", r2d2_debug.errors[:r2d2_instance][0]
    assert !r2d2_debug.save
  end

  test "should not create a r2d2_debug if r2d2_instance is smaller than 0 or larger than 7" do
    r2d2_debug = R2d2Debug.new

    r2d2_debug.r2d2_instance = -10
    assert !r2d2_debug.valid?
    assert r2d2_debug.errors[:r2d2_instance].any?
    assert_equal "is not included in the list", r2d2_debug.errors[:r2d2_instance][0]
    assert !r2d2_debug.save

    r2d2_debug.r2d2_instance = 10
    assert !r2d2_debug.valid?
    assert r2d2_debug.errors[:r2d2_instance].any?
    assert_equal "is not included in the list", r2d2_debug.errors[:r2d2_instance][0]
    assert !r2d2_debug.save
  end

  test "should not create an r2d2_debug if interface is not two character" do
    r2d2_debug = R2d2Debug.new
    r2d2_debug.interface = "T"  

    assert !r2d2_debug.valid?  
    assert r2d2_debug.errors[:interface].any?
    assert_equal "is the wrong length (should be 2 characters)", r2d2_debug.errors[:interface][0]
    assert !r2d2_debug.save

    r2d2_debug.interface = "Transmit"  

    assert !r2d2_debug.valid?  
    assert r2d2_debug.errors[:interface].any?
    assert_equal "is the wrong length (should be 2 characters)", r2d2_debug.errors[:interface][0]
    assert !r2d2_debug.save
  end

  test "should not create an r2d2_debug if interface does not have the correct format" do
    r2d2_debug = R2d2Debug.new
    r2d2_debug.interface = "tx"  

    assert !r2d2_debug.valid?  
    assert r2d2_debug.errors[:interface].any?
    assert_equal "is invalid", r2d2_debug.errors[:interface][0]
    assert !r2d2_debug.save

    r2d2_debug.interface = "Rs"  

    assert !r2d2_debug.valid?  
    assert r2d2_debug.errors[:interface].any?
    assert_equal "is invalid", r2d2_debug.errors[:interface][0]
    assert !r2d2_debug.save
  end

  test "should not create an r2d2_debug if serial_number is smaller than 11 chars or larger than 15 chars" do
    r2d2_debug = R2d2Debug.new
    r2d2_debug.serial_number = "SAD1000"  

    assert !r2d2_debug.valid?  
    assert r2d2_debug.errors[:serial_number].any?
    assert_equal "is too short (minimum is 11 characters)", r2d2_debug.errors[:serial_number][0]
    assert !r2d2_debug.save

    r2d2_debug.serial_number = "SAD1000000000000000WM"  

    assert !r2d2_debug.valid?  
    assert r2d2_debug.errors[:serial_number].any?
    assert_equal "is too long (maximum is 15 characters)", r2d2_debug.errors[:serial_number][0]
    assert !r2d2_debug.save
  end

  test "should not create an r2d2_debug if serial_number does not have the correct format" do
    r2d2_debug = R2d2Debug.new
    r2d2_debug.serial_number = "sad1000000XY"  

    assert !r2d2_debug.valid?  
    assert r2d2_debug.errors[:serial_number].any?
    assert_equal "is invalid", r2d2_debug.errors[:serial_number][0]
    assert !r2d2_debug.save

    r2d2_debug.serial_number = "SAD100ABCXY"  

    assert !r2d2_debug.valid?  
    assert r2d2_debug.errors[:serial_number].any?
    assert_equal "is invalid", r2d2_debug.errors[:serial_number][0]
    assert !r2d2_debug.save

    r2d2_debug.serial_number = "SAD100000XY1"  

    assert !r2d2_debug.valid?  
    assert r2d2_debug.errors[:serial_number].any?
    assert_equal "is invalid", r2d2_debug.errors[:serial_number][0]
    assert !r2d2_debug.save
  end
end
