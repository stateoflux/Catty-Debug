require 'test_helper'

class RxMemoryTest < ActiveSupport::TestCase
# CRUD TESTING
#------------------------------------------------------------------------------
  test "should create rx_memory" do
    rx_memory = Factory.build(:rx_memory)
    assert rx_memory.save 
  end

  test "should find rx_memory" do
    # assert that no exception is raised when a find is executed on the 
    # RxMemory class...tests that read operation is working
    assert_nothing_raised { RxMemory.find(Factory(:rx_memory).id) }
  end

  test "should update rx_memory" do
    rx_memory = Factory(:rx_memory)
    # update rx_memory that was created above
    assert rx_memory.update_attributes(:refdes => 'U1001') 
  end

  test "should destroy rx_memory" do
    rx_memory = Factory(:rx_memory)
    rx_memory.destroy

    # assert that find method will cause a RecordNotFound exception since this record should have been deleted.
    assert_raise(ActiveRecord::RecordNotFound) { RxMemory.find(rx_memory.id) } 
  end

# VALIDATION TESTING
#------------------------------------------------------------------------------
  test "should not create rx_memory without any of its attributes" do
    rx_memory = Factory.build(:rx_memory, :instance => nil, :part_number => nil, :refdes => nil)
    # assert that rx_memory object is not valid since instance, part_number and refdes were not specified
    assert !rx_memory.valid?  
    # assert that rx_memory object will have a instance, part_number and refdes entry in it's error hash 
    assert rx_memory.errors[:instance].any?
    assert rx_memory.errors[:part_number].any?
    assert rx_memory.errors[:refdes].any?
    # assert that rx_memory object will have error messages that are equal to "can't be blank" 
    assert_equal "can't be blank", rx_memory.errors[:instance][0]
    assert_equal "can't be blank", rx_memory.errors[:part_number][0]
    assert_equal "can't be blank", rx_memory.errors[:refdes][0]
    # assert that rx_memory object will not get saved to a table since instance, part_number and refdes were not specified
    assert !rx_memory.save
  end

  test "should not create rx_memory if instance is not a number" do
    rx_memory = Factory.build(:rx_memory)
    rx_memory.instance = "One"  
    assert !rx_memory.valid?  
    assert rx_memory.errors[:instance].any?
    assert_equal "is not a number", rx_memory.errors[:instance][0]
    assert !rx_memory.save
  end

  test "should not create rx_memory if instance is not an integer" do
    rx_memory = Factory.build(:rx_memory)
    rx_memory.instance = 2.5
    assert !rx_memory.valid?  
    assert rx_memory.errors[:instance].any?
    assert_equal "must be an integer", rx_memory.errors[:instance][0]
    assert !rx_memory.save
  end

  test "should not create rx_memory if instance is not a number between 0 - 3" do
    rx_memory = Factory.build(:rx_memory)
    rx_memory.instance = 4  
    assert !rx_memory.valid?  
    assert rx_memory.errors[:instance].any?
    assert_equal "is not included in the list", rx_memory.errors[:instance][0]
    assert !rx_memory.save
  end

  test "should not create rx_memory if part_number is shorter than 10 chars or longer than 12 chars" do
    rx_memory = Factory.build(:rx_memory)
    rx_memory.part_number = "15-100-01"
    assert !rx_memory.valid?  
    assert rx_memory.errors[:part_number].any?
    assert_equal "is too short (minimum is 10 characters)", rx_memory.errors[:part_number][0]
    assert !rx_memory.save

    rx_memory.part_number = "15-10000000-01"

    assert !rx_memory.valid?  
    assert rx_memory.errors[:part_number].any?
    assert_equal "is too long (maximum is 12 characters)", rx_memory.errors[:part_number][0]
    assert !rx_memory.save
  end

  test "should not create rx_memory if part_number has the incorrect format" do
    rx_memory = Factory.build(:rx_memory)
    rx_memory.part_number = "17-1000-01" 
    assert !rx_memory.valid?  
    assert rx_memory.errors[:part_number].any?
    assert_equal "is invalid", rx_memory.errors[:part_number][0]
    assert !rx_memory.save
    
    rx_memory.part_number = "15-10000-2"   

    assert !rx_memory.valid?  
    assert rx_memory.errors[:part_number].any?
    assert_equal "is invalid", rx_memory.errors[:part_number][0]
    assert !rx_memory.save
  end

  test "should not create rx_memory if refdes is shorter than 2 chars or longer than 6 chars" do
    rx_memory = Factory.build(:rx_memory)
    rx_memory.refdes = "U"
    assert !rx_memory.valid?  
    assert rx_memory.errors[:refdes].any?
    assert_equal "is too short (minimum is 2 characters)", rx_memory.errors[:refdes][0]
    assert !rx_memory.save

    rx_memory.refdes = "U100000000"

    assert !rx_memory.valid?  
    assert rx_memory.errors[:refdes].any?
    assert_equal "is too long (maximum is 6 characters)", rx_memory.errors[:refdes][0]
    assert !rx_memory.save
  end

  test "should not create rx_memory if refdes has the incorrect format" do
    rx_memory = Factory.build(:rx_memory)
    rx_memory.refdes = "R39" 
    assert !rx_memory.valid?  
    assert rx_memory.errors[:refdes].any?
    assert_equal "is invalid", rx_memory.errors[:refdes][0]
    assert !rx_memory.save
    
    rx_memory.refdes = "U392-"   

    assert !rx_memory.valid?  
    assert rx_memory.errors[:refdes].any?
    assert_equal "is invalid", rx_memory.errors[:refdes][0]
    assert !rx_memory.save
  end
end
