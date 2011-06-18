require 'test_helper'

class TxMemoryTest < ActiveSupport::TestCase
# CRUD TESTING
#------------------------------------------------------------------------------
  test "should create tx_memory" do
    tx_memory = Factory.build(:tx_memory)
    assert tx_memory.save 
  end

  test "should find tx_memory" do
    # assert that no exception is raised when a find is executed on the 
    # TxMemory class...tests that read operation is working
    assert_nothing_raised { TxMemory.find(Factory(:tx_memory).id) }
  end

  test "should update tx_memory" do
    tx_memory = Factory(:tx_memory)
    # update tx_memory that was created above
    assert tx_memory.update_attributes(:refdes => 'U1001') 
  end

  test "should destroy tx_memory" do
    tx_memory = Factory(:tx_memory)
    tx_memory.destroy

    # assert that find method will cause a RecordNotFound exception since this record should have been deleted.
    assert_raise(ActiveRecord::RecordNotFound) { TxMemory.find(tx_memory.id) } 
  end

# VALIDATION TESTING
#------------------------------------------------------------------------------
  test "should not create tx_memory without any of its attributes" do
    tx_memory = Factory.build(:tx_memory, :instance => nil, :part_number => nil, :refdes => nil)
    # assert that tx_memory object is not valid since instance, part_number and refdes were not specified
    assert !tx_memory.valid?  
    # assert that tx_memory object will have a instance, part_number and refdes entry in it's error hash 
    assert tx_memory.errors[:instance].any?
    assert tx_memory.errors[:part_number].any?
    assert tx_memory.errors[:refdes].any?
    # assert that tx_memory object will have error messages that are equal to "can't be blank" 
    assert_equal "can't be blank", tx_memory.errors[:instance][0]
    assert_equal "can't be blank", tx_memory.errors[:part_number][0]
    assert_equal "can't be blank", tx_memory.errors[:refdes][0]
    # assert that tx_memory object will not get saved to a table since instance, part_number and refdes were not specified
    assert !tx_memory.save
  end

  test "should not create tx_memory if instance is not a number" do
    tx_memory = Factory.build(:tx_memory)
    tx_memory.instance = "One"  
    assert !tx_memory.valid?  
    assert tx_memory.errors[:instance].any?
    assert_equal "is not a number", tx_memory.errors[:instance][0]
    assert !tx_memory.save
  end

  test "should not create tx_memory if instance is not an integer" do
    tx_memory = Factory.build(:tx_memory)
    tx_memory.instance = 2.8
    assert !tx_memory.valid?  
    assert tx_memory.errors[:instance].any?
    assert_equal "must be an integer", tx_memory.errors[:instance][0]
    assert !tx_memory.save
  end

  test "should not create tx_memory if instance is not a number between 0 - 3" do
    tx_memory = Factory.build(:tx_memory)
    tx_memory.instance = 4  
    assert !tx_memory.valid?  
    assert tx_memory.errors[:instance].any?
    assert_equal "is not included in the list", tx_memory.errors[:instance][0]
    assert !tx_memory.save
  end

  test "should not create tx_memory if part_number is shorter than 10 chars or longer than 12 chars" do
    tx_memory = Factory.build(:tx_memory)
    tx_memory.part_number = "15-100-01"
    assert !tx_memory.valid?  
    assert tx_memory.errors[:part_number].any?
    assert_equal "is too short (minimum is 10 characters)", tx_memory.errors[:part_number][0]
    assert !tx_memory.save

    tx_memory.part_number = "15-10000000-01"

    assert !tx_memory.valid?  
    assert tx_memory.errors[:part_number].any?
    assert_equal "is too long (maximum is 12 characters)", tx_memory.errors[:part_number][0]
    assert !tx_memory.save
  end

  test "should not create tx_memory if part_number has the incorrect format" do
    tx_memory = Factory.build(:tx_memory)
    tx_memory.part_number = "17-1000-01" 
    assert !tx_memory.valid?  
    assert tx_memory.errors[:part_number].any?
    assert_equal "is invalid", tx_memory.errors[:part_number][0]
    assert !tx_memory.save
    
    tx_memory.part_number = "15-10000-2"   

    assert !tx_memory.valid?  
    assert tx_memory.errors[:part_number].any?
    assert_equal "is invalid", tx_memory.errors[:part_number][0]
    assert !tx_memory.save
  end

  test "should not create tx_memory if refdes is shorter than 2 chars or longer than 6 chars" do
    tx_memory = Factory.build(:tx_memory)
    tx_memory.refdes = "U"
    assert !tx_memory.valid?  
    assert tx_memory.errors[:refdes].any?
    assert_equal "is too short (minimum is 2 characters)", tx_memory.errors[:refdes][0]
    assert !tx_memory.save

    tx_memory.refdes = "U100000000"

    assert !tx_memory.valid?  
    assert tx_memory.errors[:refdes].any?
    assert_equal "is too long (maximum is 6 characters)", tx_memory.errors[:refdes][0]
    assert !tx_memory.save
  end

  test "should not create tx_memory if refdes has the incorrect format" do
    tx_memory = Factory.build(:tx_memory)
    tx_memory.refdes = "R39" 
    assert !tx_memory.valid?  
    assert tx_memory.errors[:refdes].any?
    assert_equal "is invalid", tx_memory.errors[:refdes][0]
    assert !tx_memory.save
    
    tx_memory.refdes = "U392-"   

    assert !tx_memory.valid?  
    assert tx_memory.errors[:refdes].any?
    assert_equal "is invalid", tx_memory.errors[:refdes][0]
    assert !tx_memory.save
  end
end
