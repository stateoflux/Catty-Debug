require 'test_helper'

class RxMemoriesControllerTest < ActionController::TestCase
  setup do
    @rx_memory = rx_memories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rx_memories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rx_memory" do
    assert_difference('RxMemory.count') do
      post :create, :rx_memory => @rx_memory.attributes
    end

    assert_redirected_to rx_memory_path(assigns(:rx_memory))
  end

  test "should show rx_memory" do
    get :show, :id => @rx_memory.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @rx_memory.to_param
    assert_response :success
  end

  test "should update rx_memory" do
    put :update, :id => @rx_memory.to_param, :rx_memory => @rx_memory.attributes
    assert_redirected_to rx_memory_path(assigns(:rx_memory))
  end

  test "should destroy rx_memory" do
    assert_difference('RxMemory.count', -1) do
      delete :destroy, :id => @rx_memory.to_param
    end

    assert_redirected_to rx_memories_path
  end
end
