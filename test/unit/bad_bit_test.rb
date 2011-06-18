require 'test_helper'

class BadBitTest < ActiveSupport::TestCase

# CRUD TESTING
#------------------------------------------------------------------------------
  test "should create bad_bit" do
    bad_bit = Factory.build(:bad_bit)
    assert bad_bit.save, "Failed to save bad_bit" 
  end

  test "should find bad_bit" do
    # assert that no exception is raised when a find is executed on the 
    # bad_bit class...tests that read operation is working
    assert_nothing_raised { BadBit.find(Factory(:bad_bit).id) }
  end

  test "should update bad_bit" do
    bad_bit = Factory(:bad_bit)
    # Update the bad_bit that was created above
    assert bad_bit.update_attributes(:bad_bit => 574), "Failed to update attributes of bad_bit"
  end

  test "should destroy bad_bit" do
    bad_bit = Factory(:bad_bit, :bad_bit => 175)
    bad_bit.destroy
    # assert that find method will cause a RecordNotFound exception since this record should have been deleted.
    assert_raise(ActiveRecord::RecordNotFound) { BadBit.find(bad_bit.id) }
  end

# VALIDATION TESTING
#------------------------------------------------------------------------------
  test "should not create a bad_bit without a bad_bit" do
    bad_bit = Factory.build(:bad_bit, :bad_bit => nil, :r2d2_debugs => [])
    # assert that bad_bit object is not valid since bad_bit was not specified
    assert !bad_bit.valid?  
    # assert that bad_bit object will have a bad_bit entry in it's error hash 
    assert bad_bit.errors[:bad_bit].any?
    # assert bad_bit.errors[:r2d2_debugs].any?
    # assert that bad_bit object will have error messages that are equal to "can't be blank" 
    assert_equal "can't be blank", bad_bit.errors[:bad_bit][0]
    # assert_equal "can't be blank", bad_bit.errors[:r2d2_debugs][0]
    # assert that bad_bit object will not get saved to a table since bad_bit and admin were not specified
    assert !bad_bit.save
  end

  test "should not create a bad_bit if bad_bit is not a number" do
    bad_bit = Factory.build(:bad_bit)
    bad_bit.bad_bit = "one"
    assert !bad_bit.valid?  
    assert bad_bit.errors[:bad_bit].any?
    assert_equal "is not a number", bad_bit.errors[:bad_bit][0]
    assert !bad_bit.save
  end

  test "should not create bad_bit if bad_bit is smaller than zero or larger than 575" do
    bad_bit = Factory.build(:bad_bit)
    bad_bit.bad_bit = -10 
    assert !bad_bit.valid?  
    assert bad_bit.errors[:bad_bit].any?
    assert_equal "is not included in the list", bad_bit.errors[:bad_bit][0]
    assert !bad_bit.save

    bad_bit.bad_bit = 600 

    assert !bad_bit.valid?  
    assert bad_bit.errors[:bad_bit].any?
    assert_equal "is not included in the list", bad_bit.errors[:bad_bit][0]
    assert !bad_bit.save
  end

# METHOD TESTING
#------------------------------------------------------------------------------
  test "cycle method should return correct value" do
    bad_bit = Factory.build(:bad_bit)
    500.times do
      test_bit = rand(575)
      bad_bit.bad_bit = test_bit 
      if test_bit <= 287 
        expected = "2nd" 
      else
        expected = "1st"
      end
      assert_equal expected, bad_bit.cycle, "cycle returned the wrong value (bit #{test_bit} -> #{expected} : #{bad_bit.cycle})"
    end
  end
end
