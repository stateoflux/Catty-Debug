require 'test_helper'

class AssembliesControllerTest < ActionController::TestCase
  setup do
    #@r2d2_debug = Factory.build(:r2d2_debug, )  # Assoc assembly will be created as well
    @assembly = Factory(:assembly)
    @wayne = Factory(:user)
    @mikki = build_mikki
  end

  test "should get index" do
    Factory(:r2d2_debug, :user => @wayne)
    login_as(@wayne)
    get :index                            # http verb get used to request the index action
    assert_response :success              # asserts that the request has successfully handled
    assert_template 'index'
    assert_not_nil assigns(:assemblies)   # asserts that an @assemblies variable has been set
    assert_not_nil assigns(:users)        # asserts that an @waynes variable has been set
    assert_not_nil assigns(:r2d2_debugs)  # asserts that an @r2d2_debugs variable has been set
  end

  test "should get new" do
    login_as(@wayne)
    get :new
    assert_response :success
  end

  test "should create assembly" do
    login_as(@wayne)
    # asserts that Assembly.count will be different by one after the block excutes its code
    assert_difference('Assembly.count') do
      post :create, :assembly => Factory.attributes_for(:assembly)
    end
    assert_redirected_to assemblies_path  # asserts that a redirect to page that displays the newly created assembly
                                          # if redirect is true, then we know the assembly was saved to the database
  end

  # test the failing path of the create action
  test "should not create assembly" do
    login_as(@wayne)
    # bad_attribute method updates one of  attributes returned from the Factory generator 
    # such that the assembly will not validate
    post :create, :assembly => bad_attribute 
    assert_template 'new' 
  end

  test "should show assembly" do
    login_as(@wayne)
    get :show, :id => @assembly.to_param  # .to_param returns the object's id parameter
    assert_response :success
    assert_not_nil assigns(:assembly)
    assert assigns(:assembly).valid?
    assert_template 'show'
  end

  test "should get edit" do
    login_as(@wayne)
    get :edit, :id => @assembly.to_param
    assert_response :success
  end

  test "should update assembly" do
    login_as(@wayne)
    put :update, :id => @assembly.to_param, :assembly => {:project_name => 'Heathland'} 
    assert_redirected_to assemblies_path
  end
  
  # test should not update the assembly
  test "should not update assembly" do
    login_as(@wayne)
    put :update, :id => @assembly.to_param, :assembly => {:project_name => '1Heathland'} 
    assert_template 'edit'
  end

  test "should destroy assembly" do
    login_as(@wayne)
    assert_nothing_raised { Assembly.find(@assembly.to_param) }
    assert_difference('Assembly.count', -1) do
      delete :destroy, :id => @assembly.to_param
    end
    assert_response :redirect
    assert_redirected_to assemblies_path
    assert_raise(ActiveRecord::RecordNotFound) { Assembly.find(@assembly.to_param) } 
  end


#------------------------------------------------------------------------------
# Mikki is a normal user, so she is restricted from all assembly controller  
# actions
#------------------------------------------------------------------------------
  test "mikki should not get index" do
    login_as(@mikki)
    get :index                            # http verb get used to request the index action
    assert_redirected_to user_path @mikki # redirects mikki back to her home page 
  end

  test "mikki should not get new" do
    login_as(@mikki)
    get :new
    assert_redirected_to user_path @mikki # redirects mikki back to her home page 
  end

  test "mikki should not create assembly" do
    login_as(@mikki)
    post :create, :assembly => Factory.attributes_for(:assembly)
    assert_redirected_to user_path @mikki # redirects mikki back to her home page 
  end

  test "mikki should not show assembly" do
    login_as(@mikki)
    get :show, :id => @assembly.to_param  # .to_param returns the object's id parameter
    assert_redirected_to user_path @mikki # redirects mikki back to her home page 
  end

  test "mikki should not get edit" do
    login_as(@mikki)
    get :edit, :id => @assembly.to_param
    assert_redirected_to user_path @mikki # redirects mikki back to her home page 
  end

  test "mikki should not update assembly" do
    login_as(@mikki)
    put :update, :id => @assembly.to_param, :assembly => {:project_name => 'Heathland'} 
    assert_redirected_to user_path @mikki # redirects mikki back to her home page 
  end
  
  test "mikki should not destroy assembly" do
    login_as(@mikki)
    assert_nothing_raised { Assembly.find(@assembly.to_param) }
    delete :destroy, :id => @assembly.to_param
    assert_redirected_to user_path @mikki # redirects mikki back to her home page 
  end

  def bad_attribute
    attrs = Factory.attributes_for(:assembly)
    attrs[:num_of_r2d2s] = 10
    attrs
  end
end
