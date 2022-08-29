require "test_helper"

class ReadiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ready = readies(:one)
  end

  test "should get index" do
    get readies_url
    assert_response :success
  end

  test "should get new" do
    get new_ready_url
    assert_response :success
  end

  test "should create ready" do
    assert_difference("Ready.count") do
      post readies_url, params: { ready: {  } }
    end

    assert_redirected_to ready_url(Ready.last)
  end

  test "should show ready" do
    get ready_url(@ready)
    assert_response :success
  end

  test "should get edit" do
    get edit_ready_url(@ready)
    assert_response :success
  end

  test "should update ready" do
    patch ready_url(@ready), params: { ready: {  } }
    assert_redirected_to ready_url(@ready)
  end

  test "should destroy ready" do
    assert_difference("Ready.count", -1) do
      delete ready_url(@ready)
    end

    assert_redirected_to readies_url
  end
end
