require 'test_helper'

class R2d2Test < ActiveSupport::TestCase

# CRUD Testing
#------------------------------------------------------------------------------
  test "should create r2d2" do
    r2d2 = Factory.build(:r2d2) 
    assert r2d2.save 
  end

  test "should find r2d2" do
    # assert that no exception is raised when a find is executed on the 
    # Assembly class...tests that read operation is working
    assert_nothing_raised { R2d2.find(Factory(:r2d2).id) }
  end

  test "should update r2d2" do
    r2d2 = Factory(:r2d2)
    # Locate the r2d2 created above and update an attribute 
    assert R2d2.update_all "id = #{r2d2.id}", :instance => 0, :refdes => 'U100'
  end

  test "should destroy r2d2" do
    r2d2 = Factory(:r2d2) 
    r2d2.destroy
    # assert that find method will cause a RecordNotFound exception since this record should have been deleted.
    assert_raise(ActiveRecord::RecordNotFound) { R2d2.find(r2d2.id) } 
  end

# VALIDATION TESTING
#------------------------------------------------------------------------------
  test "should not create an r2d2 without any of its attributes" do
    r2d2 = Factory.build(:r2d2, :instance => nil, :part_number => nil,
                         :refdes => nil, :tx_memories => [], 
                         :rx_memories => [])

    # assert that r2d2 object is not valid since instance, part_number and refdes were not specified
    assert !r2d2.valid?  
    # assert that r2d2 object will have a instance, part_number and refdes entry in it's error hash 
    assert r2d2.errors[:instance].any?
    assert r2d2.errors[:part_number].any?
    assert r2d2.errors[:refdes].any?
    assert r2d2.errors[:tx_memories].any?
    assert r2d2.errors[:rx_memories].any?
    #assert r2d2.errors[:assembly].any?
    # assert that r2d2 object will have error messages that are equal to "can't be blank" 
    assert_equal "can't be blank", r2d2.errors[:instance][0]
    assert_equal "can't be blank", r2d2.errors[:part_number][0]
    assert_equal "can't be blank", r2d2.errors[:refdes][0]
    assert_equal "can't be blank", r2d2.errors[:tx_memories][0]
    assert_equal "can't be blank", r2d2.errors[:rx_memories][0]
    #assert_equal "can't be blank", r2d2.errors[:assembly][0]
    # assert that r2d2 object will not get saved to a table since instance, part_number and refdes were not specified
    assert !r2d2.save
  end

  test "should not create an r2d2 if instance is not a number" do
    r2d2 = Factory.build(:r2d2)
    #r2d2.instance = "1"  
    r2d2.instance = "One"  
    assert !r2d2.valid?  
    assert r2d2.errors[:instance].any?
    assert_equal "is not a number", r2d2.errors[:instance][0]
    assert !r2d2.save
  end

  test "should not create an r2d2 if instance is not a integer" do
    r2d2 = Factory.build(:r2d2)
    r2d2.instance = 3.2  
    assert !r2d2.valid?  
    assert r2d2.errors[:instance].any?
    assert_equal "must be an integer", r2d2.errors[:instance][0]
    assert !r2d2.save
  end

  test "should not create an r2d2 if instance is not a number between 0 - 7" do
    r2d2 = Factory.build(:r2d2)
    r2d2.instance = 10  
    assert !r2d2.valid?  
    assert r2d2.errors[:instance].any?
    assert_equal "is not included in the list", r2d2.errors[:instance][0]
    assert !r2d2.save
  end

  test "should not create an r2d2 if part_number is shorter than 10 chars or longer than 12 chars" do
    r2d2 = Factory.build(:r2d2)
    r2d2.part_number = "08-100-01"
    assert !r2d2.valid?  
    assert r2d2.errors[:part_number].any?
    assert_equal "is too short (minimum is 10 characters)", r2d2.errors[:part_number][0]
    assert !r2d2.save

    r2d2.part_number = "08-10000000-01"

    assert !r2d2.valid?  
    assert r2d2.errors[:part_number].any?
    assert_equal "is too long (maximum is 12 characters)", r2d2.errors[:part_number][0]
    assert !r2d2.save
  end

  test "should not create an r2d2 if part_number has the incorrect format" do
    r2d2 = Factory.build(:r2d2)
    r2d2.part_number = "09-1000-01" 
    assert !r2d2.valid?  
    assert r2d2.errors[:part_number].any?
    assert_equal "is invalid", r2d2.errors[:part_number][0]
    assert !r2d2.save
    
    r2d2.part_number = "08-10000-2"   

    assert !r2d2.valid?  
    assert r2d2.errors[:part_number].any?
    assert_equal "is invalid", r2d2.errors[:part_number][0]
    assert !r2d2.save
  end

  test "should not create an r2d2 if refdes is shorter than 2 chars or longer than 6 chars" do
    r2d2 = Factory.build(:r2d2)
    r2d2.refdes = "U"
    assert !r2d2.valid?  
    assert r2d2.errors[:refdes].any?
    assert_equal "is too short (minimum is 2 characters)", r2d2.errors[:refdes][0]
    assert !r2d2.save

    r2d2.refdes = "U100000000"

    assert !r2d2.valid?  
    assert r2d2.errors[:refdes].any?
    assert_equal "is too long (maximum is 6 characters)", r2d2.errors[:refdes][0]
    assert !r2d2.save
  end

  test "should not create an r2d2 if refdes has the incorrect format" do
    r2d2 = Factory.build(:r2d2)
    r2d2.refdes = "R39" 
    assert !r2d2.valid?  
    assert r2d2.errors[:refdes].any?
    assert_equal "is invalid", r2d2.errors[:refdes][0]
    assert !r2d2.save
    
    r2d2.refdes = "U392-"   

    assert !r2d2.valid?  
    assert r2d2.errors[:refdes].any?
    assert_equal "is invalid", r2d2.errors[:refdes][0]
    assert !r2d2.save
  end
end
