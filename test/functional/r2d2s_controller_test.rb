require 'test_helper'

class R2d2sControllerTest < ActionController::TestCase
  setup do
    @r2d2 = r2d2s(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:r2d2s)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create r2d2" do
    assert_difference('R2d2.count') do
      post :create, :r2d2 => @r2d2.attributes
    end

    assert_redirected_to r2d2_path(assigns(:r2d2))
  end

  test "should show r2d2" do
    get :show, :id => @r2d2.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @r2d2.to_param
    assert_response :success
  end

  test "should update r2d2" do
    put :update, :id => @r2d2.to_param, :r2d2 => @r2d2.attributes
    assert_redirected_to r2d2_path(assigns(:r2d2))
  end

  test "should destroy r2d2" do
    assert_difference('R2d2.count', -1) do
      delete :destroy, :id => @r2d2.to_param
    end

    assert_redirected_to r2d2s_path
  end
end
