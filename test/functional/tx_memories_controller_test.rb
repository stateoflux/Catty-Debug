require 'test_helper'

class TxMemoriesControllerTest < ActionController::TestCase
  setup do
    @tx_memory = tx_memories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tx_memories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tx_memory" do
    assert_difference('TxMemory.count') do
      post :create, :tx_memory => @tx_memory.attributes
    end

    assert_redirected_to tx_memory_path(assigns(:tx_memory))
  end

  test "should show tx_memory" do
    get :show, :id => @tx_memory.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @tx_memory.to_param
    assert_response :success
  end

  test "should update tx_memory" do
    put :update, :id => @tx_memory.to_param, :tx_memory => @tx_memory.attributes
    assert_redirected_to tx_memory_path(assigns(:tx_memory))
  end

  test "should destroy tx_memory" do
    assert_difference('TxMemory.count', -1) do
      delete :destroy, :id => @tx_memory.to_param
    end

    assert_redirected_to tx_memories_path
  end
end
