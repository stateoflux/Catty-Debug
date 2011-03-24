require 'test_helper'

class ReworkRequestTest < ActiveSupport::TestCase
  # CRUD TESTING
  test "should create rework_request" do
    rework_request = ReworkRequest.new
    rework_request.board_name = "Sup2T"
    rework_request.two_day_turn = true
    rework_request.instructions = "Replace the bloodclaat ting" 
    rework_request.bake = true 

    assert rework_request.save 
  end

  test "should find rework_request" do
    rework_request_id = rework_requests(:rework_1).id
    
    # assert that no exception is raised when a find is executed on the 
    # ReworkRequest class...tests that read operation is working
    assert_nothing_raised { ReworkRequest.find(rework_request_id) }
  end

  test "should update rework_request" do
    rework_request = rework_requests(:rework_1)

    assert rework_request.update_attributes(:instructions => "Man, tear off di bleeding ting"), "Failed to update attributes of rework_request"
  end

  test "should destroy rework_request" do
    rework_request = rework_requests(:rework_1)

    rework_request.destroy
    # assert that find method will cause a RecordNotFound exception since this record should have been deleted.
    assert_raise(ActiveRecord::RecordNotFound) { ReworkRequest.find(rework_request.id) } 
  end

# VALIDATION TESTING
  test "should not create a rework_request without valid attributes" do
    rework_request = ReworkRequest.new

    # assert that rework_request object is not valid since board_name and two_day_turn was not specified
    assert !rework_request.valid?  
    # assert that rework_request object will have a board_name entry in it's error hash 
    assert rework_request.errors[:board_name].any?
    assert rework_request.errors[:two_day_turn].any?
    assert rework_request.errors[:instructions].any?
    assert rework_request.errors[:bake].any?
    # assert that rework_request object will have error messages that are equal to "can't be blank" 
    assert_equal "can't be blank", rework_request.errors[:board_name][0]
    assert_equal "can't be blank", rework_request.errors[:two_day_turn][0]
    assert_equal "can't be blank", rework_request.errors[:instructions][0]
    assert_equal "can't be blank", rework_request.errors[:bake][0]
    # assert that rework_request object will not get saved to a table since board_name and two_day_turn were not specified
    assert !rework_request.save
  end

  test "should not create rework_request if board_name is shorter than 3 chars or longer than 20 chars" do
    rework_request = ReworkRequest.new
    rework_request.board_name = "wm"

    assert !rework_request.valid?  
    assert rework_request.errors[:board_name].any?
    assert_equal "is too short (minimum is 3 characters)", rework_request.errors[:board_name][0]
    assert !rework_request.save

    rework_request.board_name = "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"

    assert !rework_request.valid?  
    assert rework_request.errors[:board_name].any?
    assert_equal "is too long (maximum is 20 characters)", rework_request.errors[:board_name][0]
    assert !rework_request.save
  end

  test "should not create a rework_request if board_name does not have the proper format" do
    rework_request = ReworkRequest.new
    rework_request.board_name = "senga"    # Must begin with a capital letter 

    assert !rework_request.valid?  
    assert rework_request.errors[:board_name].any?
    assert_equal "is invalid", rework_request.errors[:board_name][0]
    assert !rework_request.save
    
    rework_request.board_name = "sen*ga"    # Only special chars allowed are _ & - 

    assert !rework_request.valid?  
    assert rework_request.errors[:board_name].any?
    assert_equal "is invalid", rework_request.errors[:board_name][0]
    assert !rework_request.save

    rework_request.board_name = "Senga12"  # Should not end with a number 

    assert !rework_request.valid?  
    assert rework_request.errors[:board_name].any?
    assert_equal "is invalid", rework_request.errors[:board_name][0]
    assert !rework_request.save
  end

  test "should not create rework_request if instructions is shorter than 10 chars" do
    rework_request = ReworkRequest.new
    rework_request.instructions = "This mess"

    assert !rework_request.valid?  
    assert rework_request.errors[:instructions].any?
    assert_equal "is too short (minimum is 10 characters)", rework_request.errors[:instructions][0]
    assert !rework_request.save
  end
end
