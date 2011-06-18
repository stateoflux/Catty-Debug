require 'test_helper'

class UserTest < ActiveSupport::TestCase
# CRUD TESTING
#------------------------------------------------------------------------------
  test "should create user" do
    user = Factory.build(:user)
    assert user.save 
  end

  test "should find user" do
    # assert that no exception is raised when a find is executed on the 
    # User class...tests that read operation is working
    assert_nothing_raised { User.find(Factory(:user)).id }
  end

  test "should update user" do
    user = Factory(:user)
    assert user.update_attributes(:email => 'm.rosecrans@gmail.com'), "Failed to update attributes of user"
  end

  test "should destroy user" do
    user = Factory(:user)
    user.destroy
    # assert that find method will cause a RecordNotFound exception since this record should have been deleted.
    assert_raise(ActiveRecord::RecordNotFound) { User.find(user.id) } 
  end

# VALIDATION TESTING
#------------------------------------------------------------------------------
  test "should not create a user without any attributes" do
    user = Factory.build(:user, :first_name => nil, :last_name => nil,
                         :email => nil, :admin => nil)
    # assert that user object is not valid since email and admin was not specified
    assert !user.valid?  
    # assert that user object will have a email entry in it's error hash 
    assert user.errors[:first_name].any?
    assert user.errors[:last_name].any?
    assert user.errors[:email].any?
    #assert user.errors[:admin].any?
    # assert that user object will have error messages that are equal to "can't be blank" 
    assert_equal "can't be blank", user.errors[:first_name][0]
    assert_equal "can't be blank", user.errors[:last_name][0]
    assert_equal "can't be blank", user.errors[:email][0]
    #assert_equal "can't be blank", user.errors[:admin][0]
    # assert that user object will not get saved to a table since email and admin were not specified
    assert !user.save
  end

  test "should not create user if first_name is shorter than 2 chars or longer than 50 chars" do
    user = Factory.build(:user) 
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
    user = Factory.build(:user) 
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
    user = Factory.build(:user) 
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
    user = Factory.build(:user) 
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
    user = Factory.build(:user) 
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
    user = Factory.build(:user) 
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

=begin
  test "should not create user if admin is not a boolean" do
    user = Factory.build(:user) 
    user.admin = "yes"
    assert !user.valid?
    assert user.errors[:admin].any?
    assert_equal "can't be blank", user.errors[:admin][0]
    assert !user.save
  end
=end

# METHOD TESTING
#------------------------------------------------------------------------------
  test "authenticate method should return true" do
    user = Factory(:user)
    assert User.authenticate(user.email)
  end

  test "authenticate method should return false" do
    assert !User.authenticate("mikki@cisco.com")
  end
end
