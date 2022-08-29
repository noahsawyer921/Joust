require "application_system_test_case"

class MatchupsTest < ApplicationSystemTestCase
  setup do
    @matchup = matchups(:one)
  end

  test "visiting the index" do
    visit matchups_url
    assert_selector "h1", text: "Matchups"
  end

  test "should create matchup" do
    visit matchups_url
    click_on "New matchup"

    fill_in "Round", with: @matchup.round_id
    click_on "Create Matchup"

    assert_text "Matchup was successfully created"
    click_on "Back"
  end

  test "should update Matchup" do
    visit matchup_url(@matchup)
    click_on "Edit this matchup", match: :first

    fill_in "Round", with: @matchup.round_id
    click_on "Update Matchup"

    assert_text "Matchup was successfully updated"
    click_on "Back"
  end

  test "should destroy Matchup" do
    visit matchup_url(@matchup)
    click_on "Destroy this matchup", match: :first

    assert_text "Matchup was successfully destroyed"
  end
end
