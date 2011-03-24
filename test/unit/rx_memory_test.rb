require 'test_helper'

class RxMemoryTest < ActiveSupport::TestCase
  test "should create rx_memory" do
    rx_memory = RxMemory.new

    rx_memory.instance = 0 
    rx_memory.part_number = "15-11466-01" 
    rx_memory.refdes = "U100"
    rx_memory.r2d2 = r2d2s(:r2d2_0)

    assert rx_memory.save 
  end

  test "should find rx_memory" do
    rx_memory_id = rx_memories(:rx_memory_2).id
    
    # assert that no exception is raised when a find is executed on the 
    # Assembly class...tests that read operation is working
    assert_nothing_raised { RxMemory.find(rx_memory_id) }
  end

  test "should update rx_memory" do
    # update rx_memory that was created above
    assert RxMemory.update_all "instance = 1", :refdes => "U100" 
  end

  test "should destroy rx_memory" do
    rx_memory = rx_memories(:rx_memory_0)

    rx_memory.destroy

    # assert that find method will cause a RecordNotFound exception since this record should have been deleted.
    assert_raise(ActiveRecord::RecordNotFound) { RxMemory.find(rx_memory.id) } 
  end

# VALIDATION TESTING
  test "should not create an rx_memory without any of its attributes" do
    rx_memory = RxMemory.new

    # assert that rx_memory object is not valid since instance, part_number and refdes were not specified
    assert !rx_memory.valid?  
    # assert that rx_memory object will have a instance, part_number and refdes entry in it's error hash 
    assert rx_memory.errors[:instance].any?
    assert rx_memory.errors[:part_number].any?
    assert rx_memory.errors[:refdes].any?
    assert rx_memory.errors[:r2d2].any?
    # assert that rx_memory object will have error messages that are equal to "can't be blank" 
    assert_equal "can't be blank", rx_memory.errors[:instance][0]
    assert_equal "can't be blank", rx_memory.errors[:part_number][0]
    assert_equal "can't be blank", rx_memory.errors[:refdes][0]
    assert_equal "can't be blank", rx_memory.errors[:r2d2][0]
    # assert that rx_memory object will not get saved to a table since instance, part_number and refdes were not specified
    assert !rx_memory.save
  end

  test "should not create an rx_memory if instance is not a number" do
    rx_memory = RxMemory.new
    rx_memory.instance = "One"  

    assert !rx_memory.valid?  
    assert rx_memory.errors[:instance].any?
    assert_equal "is not a number", rx_memory.errors[:instance][0]
    assert !rx_memory.save
  end

  test "should not create an rx_memory if instance is not an integer" do
    rx_memory = RxMemory.new
    rx_memory.instance = 2.5

    assert !rx_memory.valid?  
    assert rx_memory.errors[:instance].any?
    assert_equal "must be an integer", rx_memory.errors[:instance][0]
    assert !rx_memory.save
  end

  test "should not create an rx_memory if instance is not a number between 0 - 3" do
    rx_memory = RxMemory.new
    rx_memory.instance = 4  

    assert !rx_memory.valid?  
    assert rx_memory.errors[:instance].any?
    assert_equal "is not included in the list", rx_memory.errors[:instance][0]
    assert !rx_memory.save
  end

  test "should not create an rx_memory if part_number is shorter than 10 chars or longer than 12 chars" do
    rx_memory = RxMemory.new
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

  test "should not create an rx_memory if part_number has the incorrect format" do
    rx_memory = RxMemory.new
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

  test "should not create an rx_memory if refdes is shorter than 2 chars or longer than 6 chars" do
    rx_memory = RxMemory.new
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

  test "should not create an rx_memory if refdes has the incorrect format" do
    rx_memory = RxMemory.new
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
