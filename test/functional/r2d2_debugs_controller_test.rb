require 'test_helper'
# The first test suites will be run with an admin logged in 
# the second test suite will be run with a normal user logged in 

class R2d2DebugsControllerTest < ActionController::TestCase
  setup do
    @wayne = Factory(:user)
    @r2d2_debug = Factory.build(:r2d2_debug, :user => nil)
    @r2d2_debug.user = @wayne
    @r2d2_debug.save
    @mikki = build_mikki
  end

  # Only admin has access to this particular action
  # but a normal user can access their debug session
  # listing via their user page
  test "should get index admin" do
    login_as @wayne
    get :index
    assert_response :success
    assert_template 'index'
    assert !assigns(:r2d2_debugs).empty?
  end

  test "should get new admin" do
    login_as @wayne
    get :new
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:r2d2_debug)
  end
  
  # Tests the passing path
  test "should create r2d2_debug admin" do
    assembly = Factory(:assembly)
    login_as @wayne
    assert_difference('R2d2Debug.count') do 
      post :create, {
        :r2d2_debug => {
          :serial_number => "SAD111222UX",
          :assembly_id => assembly.to_param
        },
        :test_result => test_result_dump
      }
    end
    assert_template 'show_results' 
    assert_not_nil assigns(:r2d2_debug)
    assert assigns(:r2d2_debug).valid?
  end

  # Tests path where test_result field is empty
  test "should not create r2d2_debug when test_result is empty admin" do
    assembly = Factory(:assembly)
    login_as @wayne
    assert_no_difference('R2d2Debug.count') do 
      post :create, {
        :r2d2_debug => {
          :serial_number => "SAD111222UX",
          :assembly_id => assembly.to_param
        },
        :test_result => "" 
      }
    end
    assert_response :success
    assert_template 'new' 
  end

  # Tests path where r2d2_debug fails to validate
  test "should not create r2d2_debug when validation fails" do
    assembly = Factory(:assembly)
    login_as @wayne
    assert_no_difference('R2d2Debug.count') do 
      post :create, {
        :r2d2_debug => {
          :serial_number => "SAD1112222222222222UX",  # cause validation to fail
          :assembly_id => assembly.to_param
        },
        :test_result => test_result_dump 
      }
    end
    assert_response :success
    assert_template 'new' 
    assert_equal "Something is wrong", flash[:alert]
  end

  # Tests the path where extract_and_set_attr method fails
  test "should not create r2d2_debug admin when extract_and_set_attr fails" do
    assembly = Factory(:assembly)
    login_as @wayne
    assert_no_difference('R2d2Debug.count') do 
      post :create, {
        :r2d2_debug => {
          :serial_number => "SAD111222UX",
          :assembly_id => assembly.to_param
        },
        :test_result => "..."  # causes extract_and_set_attr to fail
      }
    end
    assert_template 'new' 
    assert_equal "Something within this test result dump is invalid.  Please correct and re-submit",
                 flash[:alert]
  end

  test "should show admin" do
    login_as @wayne
    get :show, :id => @r2d2_debug.to_param
    assert_response :success
    assert_template 'show_results'
    assert_not_nil assigns(:r2d2_debug)
    assert assigns(:r2d2_debug).valid?
  end

  test "should destroy admin" do
    login_as @wayne
    assert_nothing_raised { R2d2Debug.find(@r2d2_debug.to_param) }
    assert_difference('R2d2Debug.count', -1) do
      delete :destroy, :id => @r2d2_debug.to_param
    end
    assert_response :redirect
    # deletion of an r2d2_object should redirect to admin dashboard (assemblies_path)
    assert_redirected_to assemblies_path    
    assert_raise(ActiveRecord::RecordNotFound) { R2d2Debug.find(@r2d2_debug.to_param) }
  end

#------------------------------------------------------------------------------  
# Mikki is a normal user, so she is restricted from all r2d2_debug actions except
# for show, new & create 
#------------------------------------------------------------------------------  
  test "should not get index normal" do
    login_as @mikki 
    # create another debug session
    mikkis_debug = Factory(:r2d2_debug, :user => @mikki)
    get :index
    assert_response :redirect
    assert_redirected_to user_path(@mikki) 
  end

  test "should get new normal" do
    login_as @mikki 
    get :new
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:r2d2_debug)
  end

  test "should create normal" do
    assembly = Factory(:assembly)
    login_as @mikki 
    assert_difference('R2d2Debug.count') do 
      post :create, {
        :r2d2_debug => {
          :serial_number => "SAD911222UX",
          :assembly_id => assembly.to_param
        },
        :test_result => test_result_dump
      }
    end
    assert_template 'show_results' 
    assert_not_nil assigns(:r2d2_debug)
    assert assigns(:r2d2_debug).valid?
  end

  # Mikki is allowed to see her own debug session plus others
  test "should show normal" do
    login_as @mikki
    mikkis_debug = Factory(:r2d2_debug, :user => @mikki)
    get :show, :id => mikkis_debug.to_param
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:r2d2_debug)
    assert assigns(:r2d2_debug).valid?

    # mikki is able to view my debug session
    get :show, :id => @r2d2_debug.to_param
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:r2d2_debug)
    assert assigns(:r2d2_debug).valid?
  end

  # Mikki should not be able to delete her own debug sessions 
  test "should not destroy normal" do
    login_as @mikki
    mikkis_debug = Factory(:r2d2_debug, :user => @mikki)
    assert_nothing_raised { R2d2Debug.find(mikkis_debug.to_param) }
    assert_no_difference('R2d2Debug.count') do
      delete :destroy, :id => mikkis_debug.to_param
    end
    assert_response :redirect
    assert_redirected_to user_path(@mikki)
    assert_nothing_raised { R2d2Debug.find(@r2d2_debug.to_param) }
  end
end
