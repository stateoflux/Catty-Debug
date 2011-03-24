require 'test_helper'

class UserTest < ActiveSupport::TestCase
# CRUD TESTING
  test "should create user" do
    user = User.new
    user.first_name = "wayne"
    user.last_name = "montague"
    user.email = "wayne.montague@gmail.com"
    user.admin = true
    assert user.save 
  end

  test "should find user" do
    user_id = users(:wayne).id
    
    # assert that no exception is raised when a find is executed on the 
    # User class...tests that read operation is working
    assert_nothing_raised { User.find(user_id) }
  end

  test "should update user" do
    user = users(:mikki)

    assert user.update_attributes(:email => 'm.rosecrans@gmail.com'), "Failed to update attributes of user"
  end

  test "should destroy user" do
    user = users(:wayne)

    user.destroy
    # assert that find method will cause a RecordNotFound exception since this record should have been deleted.
    assert_raise(ActiveRecord::RecordNotFound) { User.find(user.id) } 
  end

# VALIDATION TESTING
  test "should not create a user without an email or admin" do
    user = User.new

    # assert that user object is not valid since email and admin was not specified
    assert !user.valid?  
    # assert that user object will have a email entry in it's error hash 
    assert user.errors[:first_name].any?
    assert user.errors[:last_name].any?
    assert user.errors[:email].any?
    # assert user.errors[:admin].any?
    # assert that user object will have error messages that are equal to "can't be blank" 
    assert_equal "can't be blank", user.errors[:first_name][0]
    assert_equal "can't be blank", user.errors[:last_name][0]
    assert_equal "can't be blank", user.errors[:email][0]
    # assert_equal "can't be blank", user.errors[:admin][0]
    # assert that user object will not get saved to a table since email and admin were not specified
    assert !user.save
  end

  test "should not create user if first_name is shorter than 2 chars or longer than 50 chars" do
    user = User.new
    user.first_name = "w"

    assert !user.valid?  
    assert user.errors[:first_name].any?
    assert_equal "is too short (minimum is 2 characters)", user.errors[:first_name][0]
    assert !user.save

    user.first_name = "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"

    assert !user.valid?  
    assert user.errors[:first_name].any?
    assert_equal "is too long (maximum is 50 characters)", user.errors[:first_name][0]
    assert !user.save
  end

  test "should not create user if last_name is shorter than 2 chars or longer than 50 chars" do
    user = User.new
    user.last_name = "w"

    assert !user.valid?  
    assert user.errors[:last_name].any?
    assert_equal "is too short (minimum is 2 characters)", user.errors[:last_name][0]
    assert !user.save

    user.last_name = "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"

    assert !user.valid?  
    assert user.errors[:last_name].any?
    assert_equal "is too long (maximum is 50 characters)", user.errors[:last_name][0]
    assert !user.save
  end

  test "should not create a user if first_name does not have the proper format" do
    user = User.new
    user.first_name = "1wayne"  

    assert !user.valid?  
    assert user.errors[:first_name].any?
    assert_equal "is invalid", user.errors[:first_name][0]
    assert !user.save
    
    user.first_name = "wayne@"  # Should not end with a number 

    assert !user.valid?  
    assert user.errors[:first_name].any?
    assert_equal "is invalid", user.errors[:first_name][0]
    assert !user.save
  end

  test "should not create a user if last_name does not have the proper format" do
    user = User.new
    user.last_name = "montague^capu"  

    assert !user.valid?  
    assert user.errors[:last_name].any?
    assert_equal "is invalid", user.errors[:last_name][0]
    assert !user.save
    
    user.first_name = "mont_1_gue"  # Should not end with a number 

    assert !user.valid?  
    assert user.errors[:last_name].any?
    assert_equal "is invalid", user.errors[:last_name][0]
    assert !user.save
  end

  test "should not create user if email is shorter than 5 chars or longer than 50 chars" do
    user = User.new
    user.email = "wm"

    assert !user.valid?  
    assert user.errors[:email].any?
    assert_equal "is too short (minimum is 5 characters)", user.errors[:email][0]
    assert !user.save

    user.email = "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"

    assert !user.valid?  
    assert user.errors[:email].any?
    assert_equal "is too long (maximum is 50 characters)", user.errors[:email][0]
    assert !user.save
  end

  test "should not create a user if email does not have the proper format" do
    user = User.new
    user.email = "wayne.montague@@gmail.com"  

    assert !user.valid?  
    assert user.errors[:email].any?
    assert_equal "is invalid", user.errors[:email][0]
    assert !user.save
    
    user.email = "wayne@email.com1"  # Should not end with a number 

    assert !user.valid?  
    assert user.errors[:email].any?
    assert_equal "is invalid", user.errors[:email][0]
    assert !user.save
  end

  test "should not create user if admin is not a boolean" do
    user = User.new
    user.admin = "yes"

    assert !user.valid?
    assert !user.save
  end
end
