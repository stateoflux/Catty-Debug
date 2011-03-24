require 'test_helper'
# The first test suites will be run with an admin logged in 
# the second test suite will be run with a normal user logged in 

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:mikki)
  end

  test "should get index admin" do
    login_as :wayne
    get :index
    assert_response :success
    assert_template 'index'
    assert_not_nil assigns(:users)
  end

  test "should get new admin" do
    get :new
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:user)
  end

  test "should get create admin" do
    assert_difference('User.count') do 
      post :create, :user => {:first_name => "jules", :last_name => "Verne",
                              :email => "j.verne@gmail.com", :admin => false}
    end
    assert_response :redirect
    assert_redirected_to user_path(assigns :user)
  end

  test "should get edit admin" do
    login_as :wayne
    get :edit, :id => @user.to_param
    assert_response :success
    assert_template 'edit'
  end

  test "should get update admin" do
    login_as :wayne
    put :update, :id => @user.to_param, :user => {:last_name => "Stone"}
    assert_response :redirect
    assert_redirected_to users_path
  end

  test "should get show admin" do
    login_as :wayne
    get :show, :id => @user.to_param
    assert_response :success
    assert_template 'show'
  end

  test "should get destroy admin" do
    login_as :wayne
    assert_nothing_raised { User.find(@user.to_param) }
    assert_difference('User.count', -1) do
      delete :destroy, :id => @user.to_param
    end
    assert_response :redirect
    assert_redirected_to users_path
    assert_raise(ActiveRecord::RecordNotFound) { User.find(@user.to_param) }
  end

# Mikki is a normal user, so she is restricted from certain tasks (index & destroy)
# but she is able to edit and update her own attributes.
  
  # Mikki should not be able to access the index action
  test "should not get index normal" do
    login_as :mikki
    get :index
    assert_response :redirect
    # redirect to mikki's info page
    assert_redirected_to user_path(users(:mikki)) 
  end

  test "should get new normal" do
    get :new
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:user)
  end

  test "should get create normal" do
    assert_difference('User.count') do 
      post :create, :user => {:first_name => "jules", :last_name => "Verne",
                              :email => "j.verne@gmail.com", :admin => false}
    end
    assert_response :redirect
    assert_redirected_to user_path(assigns :user) 
  end

  test "should get edit normal" do
    login_as :mikki
    get :edit, :id => @user.to_param
    assert_response :success
    assert_template 'edit' 
  end

  test "should get update normal" do
    login_as :mikki
    put :update, :id => @user.to_param, :user => {:last_name => "Stone"}
    assert_response :redirect
    assert_redirected_to user_path(assigns :user) 
  end

  test "should get show normal" do
    login_as :mikki
    get :show, :id => @user.to_param
    assert_response :success
    assert_template 'show'
  end

  # Mikki should not be able to delete herself
  test "should not get destroy normal" do
    login_as :mikki
    assert_nothing_raised { User.find(@user.to_param) }
    assert_no_difference('User.count') do
      delete :destroy, :id => @user.to_param
    end
    assert_response :redirect
    assert_redirected_to user_path(assigns :user)
    assert_nothing_raised { User.find(@user.to_param) }
  end

=begin
# In this test suite, I'm validating that Mikki can not modify any of Wayne's attributes.
# each reponse should be a redirect back to her info page.
  setup do
    @user = users(:wayne)
  end
  
  test "should not edit someone else" do
    login_as :mikki
    get :edit, :id => @user.to_param
    assert_response :redirect
    assert_redirected_to user_path(users(:mikki)) 
  end

  test "should not update someone else" do
    login_as :mikki
    put :update, :id => @user.to_param, :user => {:last_name => "Stone"}
    assert_response :redirect
    assert_redirected_to user_path(users(:mikki))
  end

  test "should not show someone else" do
    login_as :mikki
    get :show, :id => @user.to_param
    assert_response :redirect
    assert_redirected_to user_path(users(:mikki))
  end

  # Mikki should not be able to delete another user 
  test "should not get to destroy someone else" do
    login_as :mikki
    assert_nothing_raised { User.find(@user.to_param) }
    assert_no_difference('User.count') do
      delete :destroy, :id => @user.to_param
    end
    assert_response :redirect
    assert_redirected_to user_path(users(:mikki))
    assert_nothing_raised { User.find(@user.to_param) }
  end
=end
end
