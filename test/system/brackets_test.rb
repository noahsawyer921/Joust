require "application_system_test_case"

class BracketsTest < ApplicationSystemTestCase
  setup do
    @bracket = brackets(:one)
  end

  test "visiting the index" do
    visit brackets_url
    assert_selector "h1", text: "Brackets"
  end

  test "should create bracket" do
    visit brackets_url
    click_on "New bracket"

    fill_in "Name", with: @bracket.name
    click_on "Create Bracket"

    assert_text "Bracket was successfully created"
    click_on "Back"
  end

  test "should update Bracket" do
    visit bracket_url(@bracket)
    click_on "Edit this bracket", match: :first

    fill_in "Name", with: @bracket.name
    click_on "Update Bracket"

    assert_text "Bracket was successfully updated"
    click_on "Back"
  end

  test "should destroy Bracket" do
    visit bracket_url(@bracket)
    click_on "Destroy this bracket", match: :first

    assert_text "Bracket was successfully destroyed"
  end
end
