require "test_helper"

class InitialVotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @initial_vote = initial_votes(:one)
  end

  test "should get index" do
    get initial_votes_url
    assert_response :success
  end

  test "should get new" do
    get new_initial_vote_url
    assert_response :success
  end

  test "should create initial_vote" do
    assert_difference("InitialVote.count") do
      post initial_votes_url, params: { initial_vote: { bracket_id: @initial_vote.bracket_id, choice_id: @initial_vote.choice_id, user_id: @initial_vote.user_id } }
    end

    assert_redirected_to initial_vote_url(InitialVote.last)
  end

  test "should show initial_vote" do
    get initial_vote_url(@initial_vote)
    assert_response :success
  end

  test "should get edit" do
    get edit_initial_vote_url(@initial_vote)
    assert_response :success
  end

  test "should update initial_vote" do
    patch initial_vote_url(@initial_vote), params: { initial_vote: { bracket_id: @initial_vote.bracket_id, choice_id: @initial_vote.choice_id, user_id: @initial_vote.user_id } }
    assert_redirected_to initial_vote_url(@initial_vote)
  end

  test "should destroy initial_vote" do
    assert_difference("InitialVote.count", -1) do
      delete initial_vote_url(@initial_vote)
    end

    assert_redirected_to initial_votes_url
  end
end
