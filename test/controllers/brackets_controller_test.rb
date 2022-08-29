require "test_helper"

class BracketsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bracket = brackets(:one)
  end

  test "should get index" do
    get brackets_url
    assert_response :success
  end

  test "should get new" do
    get new_bracket_url
    assert_response :success
  end

  test "should create bracket" do
    assert_difference("Bracket.count") do
      post brackets_url, params: { bracket: { name: @bracket.name } }
    end

    assert_redirected_to bracket_url(Bracket.last)
  end

  test "should show bracket" do
    get bracket_url(@bracket)
    assert_response :success
  end

  test "should get edit" do
    get edit_bracket_url(@bracket)
    assert_response :success
  end

  test "should update bracket" do
    patch bracket_url(@bracket), params: { bracket: { name: @bracket.name } }
    assert_redirected_to bracket_url(@bracket)
  end

  test "should destroy bracket" do
    assert_difference("Bracket.count", -1) do
      delete bracket_url(@bracket)
    end

    assert_redirected_to brackets_url
  end
end
