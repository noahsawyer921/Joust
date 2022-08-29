require "application_system_test_case"

class InitialVotesTest < ApplicationSystemTestCase
  setup do
    @initial_vote = initial_votes(:one)
  end

  test "visiting the index" do
    visit initial_votes_url
    assert_selector "h1", text: "Initial votes"
  end

  test "should create initial vote" do
    visit initial_votes_url
    click_on "New initial vote"

    fill_in "Bracket", with: @initial_vote.bracket_id
    fill_in "Choice", with: @initial_vote.choice_id
    fill_in "User", with: @initial_vote.user_id
    click_on "Create Initial vote"

    assert_text "Initial vote was successfully created"
    click_on "Back"
  end

  test "should update Initial vote" do
    visit initial_vote_url(@initial_vote)
    click_on "Edit this initial vote", match: :first

    fill_in "Bracket", with: @initial_vote.bracket_id
    fill_in "Choice", with: @initial_vote.choice_id
    fill_in "User", with: @initial_vote.user_id
    click_on "Update Initial vote"

    assert_text "Initial vote was successfully updated"
    click_on "Back"
  end

  test "should destroy Initial vote" do
    visit initial_vote_url(@initial_vote)
    click_on "Destroy this initial vote", match: :first

    assert_text "Initial vote was successfully destroyed"
  end
end
