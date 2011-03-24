require 'test_helper'

class AssembliesControllerTest < ActionController::TestCase
  setup do
    @assembly = assemblies(:ringar_5)
  end

  test "should get index" do
    get :index   # http verb get used to request the index action
    assert_response :success   # asserts that the request has successfully handled
    assert_not_nil assigns(:assemblies)  # asserts that an @assemblies variable has been set
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create assembly" do
    # asserts that Assembly.count will be different by one after the block excutes its code
    assert_difference('Assembly.count') do
      post :create, :assembly => @assembly.attributes
    end
    
    assert_redirected_to assembly_path(assigns(:assembly))  # asserts that a redirect to page that displays the newly created assembly
                                                            # if redirect is true, then we know the assembly was saved to the database
  end

  test "should show assembly" do
    get :show, :id => @assembly.to_param   # .to_param returns the object's id parameter
    assert_response :success
    assert_not_nil assigns(:assembly)
    assert assigns(:assembly).valid?
  end

  test "should get edit" do
    get :edit, :id => @assembly.to_param
    assert_response :success
  end

  test "should update assembly" do
    put :update, :id => @assembly.to_param, :assembly => {:project_name => 'Heathland'} 
    assert_redirected_to assembly_path(assigns(:assembly))
  end

  test "should destroy assembly" do
    assert_nothing_raised { Assembly.find(@assembly.to_param) }
    assert_difference('Assembly.count', -1) do
      delete :destroy, :id => @assembly.to_param
    end
    assert_response :redirect
    assert_redirected_to assemblies_path

    assert_raise(ActiveRecord::RecordNotFound) { Assembly.find(@assembly.to_param) } 
  end
end
