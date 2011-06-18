require 'test_helper'

class R2d2DebugTest < ActiveSupport::TestCase
# CRUD TESTING
#------------------------------------------------------------------------------
  test "should create r2d2_debug" do
    r2d2_debug = Factory.build(:r2d2_debug)
    assert r2d2_debug.save
  end

  test "should find r2d2_debug" do
    # assert that no exception is raised when a find is executed on the 
    # R2d2Debug class...tests that read operation is working
    assert_nothing_raised { R2d2Debug.find(Factory(:r2d2_debug).id) }
  end

  test "should update r2d2_debug" do
    r2d2_debug = Factory(:r2d2_debug)
    # find the r2d2_debug that was created above
    assert r2d2_debug.update_attributes(:r2d2_instance => 3, :serial_number => 'SAD111111UW')
  end

  test "should destroy r2d2_debug" do
    r2d2_debug = Factory(:r2d2_debug)
    r2d2_debug.destroy
    # assert that find method will cause a RecordNotFound exception since this record should have been deleted.
    assert_raise(ActiveRecord::RecordNotFound) { R2d2Debug.find(r2d2_debug.id) } 
  end

# VALIDATION TESTING
#------------------------------------------------------------------------------
  test "should not create a r2d2_debug without any of its attributes or associations" do
    r2d2_debug = Factory.build(:r2d2_debug, :r2d2_instance => nil,
                               :interface => nil, :serial_number => nil,
                               :data_read => nil, :assembly => nil,
                               :user => nil, :bad_bits => [])

    assert !r2d2_debug.valid?  
    assert r2d2_debug.errors[:r2d2_instance].any?
    assert r2d2_debug.errors[:interface].any?
    assert r2d2_debug.errors[:serial_number].any?
    assert r2d2_debug.errors[:data_read].any?
    assert r2d2_debug.errors[:assembly].any?
    assert r2d2_debug.errors[:user].any?
    assert r2d2_debug.errors[:bad_bits].any?
    assert_equal "can't be blank", r2d2_debug.errors[:r2d2_instance][0]
    assert_equal "can't be blank", r2d2_debug.errors[:interface][0]
    assert_equal "can't be blank", r2d2_debug.errors[:serial_number][0]
    assert_equal "can't be blank", r2d2_debug.errors[:data_read][0]
    assert_equal "can't be blank", r2d2_debug.errors[:assembly][0]
    assert_equal "can't be blank", r2d2_debug.errors[:user][0]
    assert_equal "can't be blank", r2d2_debug.errors[:bad_bits][0]
    assert !r2d2_debug.save
  end

  test "should not create a r2d2_debug if r2d2_instance is not a number" do
    r2d2_debug = Factory.build(:r2d2_debug)
    r2d2_debug.r2d2_instance = "one"
    assert !r2d2_debug.valid?  
    assert r2d2_debug.errors[:r2d2_instance].any?
    assert_equal "is not a number", r2d2_debug.errors[:r2d2_instance][0]
    assert !r2d2_debug.save
  end

  test "should not create a r2d2_debug if r2d2_instance is not an integer" do
    r2d2_debug = Factory.build(:r2d2_debug)
    r2d2_debug.r2d2_instance = 5.0 
    assert !r2d2_debug.valid?  
    assert r2d2_debug.errors[:r2d2_instance].any?
    assert_equal "must be an integer", r2d2_debug.errors[:r2d2_instance][0]
    assert !r2d2_debug.save
  end

  test "should not create a r2d2_debug if r2d2_instance is smaller than 0 or larger than 7" do
    r2d2_debug = Factory.build(:r2d2_debug)
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
    r2d2_debug = Factory.build(:r2d2_debug)
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
    r2d2_debug = Factory.build(:r2d2_debug)
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
    r2d2_debug = Factory.build(:r2d2_debug)
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
    r2d2_debug = Factory.build(:r2d2_debug)
    r2d2_debug.serial_number = "sad1000000XY"  
    assert !r2d2_debug.valid?  
    assert r2d2_debug.errors[:serial_number].any?
    assert_equal "is invalid", r2d2_debug.errors[:serial_number][0]
    assert !r2d2_debug.save

    r2d2_debug.serial_number = "SAZ100000XY1"  

    assert !r2d2_debug.valid?  
    assert r2d2_debug.errors[:serial_number].any?
    assert_equal "is invalid", r2d2_debug.errors[:serial_number][0]
    assert !r2d2_debug.save
  end
# Need to investigate validating the data read attribute  


# METHOD TESTING
#------------------------------------------------------------------------------
  test "method mem_refdes should return the correct refdes" do
    r2d2_debug = Factory.build(:r2d2_debug)
    # bit 572 is associated with memory device #3 and the debug session
    # build by factory has the failure @ TX interface of R2D2 #1
    assert_equal r2d2_debug.assembly.r2d2s[1].tx_memories[3].refdes, 
                 r2d2_debug.mem_refdes(Factory.build(:bad_bit, :bad_bit => 572))
  end

  test "method get_all_refdes should return an array of correct refdes" do
    r2d2_debug = Factory.build(:r2d2_debug)
    # bit 100 is associated with memory device #1 and the debug session
    # build by factory has the failure @ TX interface of R2D2 #1
    assert_equal [r2d2_debug.assembly.r2d2s[1].tx_memories[1].refdes], 
                 r2d2_debug.get_all_refdes
  end

  test "method get_unique_refdes should return a string of unique refdes" do
    # this r2d2_debug object has two bad_bits with the value of 100.  
    # get_unique_refdes should return a string with just one element
    r2d2_debug = Factory.build(:r2d2_debug)
    r2d2_debug.bad_bits << Factory.build(:bad_bit, :bad_bit => 100)
    assert_equal r2d2_debug.assembly.r2d2s[1].tx_memories[1].refdes, 
                 r2d2_debug.get_unique_refdes
  end

  test "extract_attr should return true when test_result is formatted correctly" do
    r2d2_debug = Factory.build(:r2d2_debug)
    assert r2d2_debug.extract_attr(test_result_dump)
    assert_equal "", r2d2_debug.validation_error
    assert_not_nil r2d2_debug.extracted_device_number
  end

  test "extract_attr should return false when test_result is formatted incorrectly" do
    r2d2_debug = Factory.build(:r2d2_debug)
    assert !r2d2_debug.extract_attr("supcalifrancalistic")
    assert_not_equal "", r2d2_debug.validation_error
  end

  test "extract_bad_bits should return array of bad bits" do
    r2d2_debug = Factory.build(:r2d2_debug)
    data_read = ["5555 5555 5555 5555 5555 5555 5555 5555 5555 55d5 5575",
                 "5555 5555 5555 5555 5555 5555 5555 5555 5555 5555 5555",
                 "5555 5555 5555 5555 5555 55d5 5575 5555 5555 5555 5555",
                 "5555 5555 5555"]
    assert_equal [423,405,135,117], r2d2_debug.extract_bad_bits("55", data_read)
  end
end
