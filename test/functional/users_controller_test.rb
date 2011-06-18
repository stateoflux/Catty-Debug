require 'test_helper'
# The first test suites will be run with an admin logged in 

class UsersControllerTest < ActionController::TestCase
  setup do
    @mikki = build_mikki 
    #@user = Factory(:user, :first_name => "mikki", :last_name => "baird-rosecrans",
    #                :email => "mikki@cisco.com", :admin => false)
  end

  test "should get index admin" do
    login_as Factory(:user) 
    get :index
    assert_response :success
    assert_template 'index'
    assert_not_nil assigns(:users)
  end

  test "should get new admin" do
    login_as Factory(:user) 
    get :new
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:user)
  end

  test "should create user admin" do
    login_as Factory(:user) 
    assert_difference('User.count') do 
      post :create, :user => {:first_name => "Jules", :last_name => "Verne",
                              :email => "jverne@cisco.com", :admin => false}
    end
    assert_response :redirect
    # after a user is created app redirects to assemblies path (admin dashboard)
    assert_redirected_to assemblies_path
    # assert_redirected_to user_path(assigns :user)
  end
  
  # Test the fail path of create action
  test "should not create user when validation fails admin" do
    login_as Factory(:user) 
    assert_no_difference('User.count') do 
      post :create, :user => {:first_name => "11Jules", :last_name => "Verne",
                              :email => "jverne@cisco.com", :admin => false}
    end
    assert_response :success
    assert_template 'new'
  end

  # Test that admin can edit someone else's data
  test "should get edit admin" do
    login_as Factory(:user) 
    get :edit, :id => @mikki.to_param
    assert_response :success
    assert_template 'edit'
  end

  # Test that admin can edit someone else's data
  test "should update user admin" do
    login_as Factory(:user) 
    put :update, :id => @mikki.to_param, :user => {:last_name => "Stone"}
    assert_response :redirect
    assert_redirected_to assemblies_path
  end

  # Test the fail path of update action 
  test "should not update user when validation fails admin" do
    login_as Factory(:user) 
    put :update, :id => @mikki.to_param, :user => {:last_name => "10Stone"}
    assert_response :success
    assert_template 'edit'
  end

  test "should show user admin" do
    login_as Factory(:user) 
    get :show, :id => @mikki.to_param
    assert_response :success
    assert_template 'show'
  end

  test "should destroy user admin" do
    login_as Factory(:user) 
    assert_nothing_raised { User.find(@mikki.to_param) }
    assert_difference('User.count', -1) do
      delete :destroy, :id => @mikki.to_param
    end
    assert_response :redirect
    assert_redirected_to assemblies_path
    assert_raise(ActiveRecord::RecordNotFound) { User.find(@mikki.to_param) }
  end

#------------------------------------------------------------------------------
# Mikki is a normal user, so she is restricted from all user CRUD operations
# except for showing & editting her own info
#------------------------------------------------------------------------------
  # Mikki should not be able to access the index action
  test "should not get index normal" do
    login_as @mikki 
    get :index
    assert_response :redirect
    # redirect to mikki's info page
    assert_redirected_to user_path(@mikki) 
    # check notice contents

  end

  # Mikki should not be able to access the new action
  test "should not get new normal" do
    login_as @mikki 
    get :new
    assert_response :redirect
    assert_redirected_to user_path(@mikki) 
  end

  # Mikki should not be able to access the create action
  test "should not create user normal" do
    login_as @mikki 
    post :create, :user => {:first_name => "jules", :last_name => "Verne",
                            :email => "j.verne@gmail.com", :admin => false}
    assert_response :redirect
    assert_redirected_to user_path(@mikki) 
  end

  # Mikki should be able to access the edit action
  test "should get edit normal" do
    login_as @mikki 
    get :edit, :id => @mikki.to_param
    assert_response :success
    assert_template 'edit'
  end

  # Mikki should be able to access the update action
  test "should update user normal" do
    login_as @mikki 
    put :update, :id => @mikki.to_param, :user => {:last_name => "Stone"}
    assert_response :redirect
    assert_redirected_to user_path(@mikki) 
  end

  # Mikki should be able to access the show action
  test "should show user normal" do
    login_as @mikki 
    get :show, :id => @mikki.to_param
    assert_response :success
    assert_template 'show'
  end

  # Mikki should not be able to delete herself
  test "should not destroy user normal" do
    login_as @mikki 
    assert_nothing_raised { User.find(@mikki.to_param) }
    delete :destroy, :id => @mikki.to_param
    assert_response :redirect
    assert_redirected_to user_path(@mikki)
    assert_nothing_raised { User.find(@mikki.to_param) }
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
