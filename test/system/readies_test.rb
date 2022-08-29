require "application_system_test_case"

class ReadiesTest < ApplicationSystemTestCase
  setup do
    @ready = readies(:one)
  end

  test "visiting the index" do
    visit readies_url
    assert_selector "h1", text: "Readies"
  end

  test "should create ready" do
    visit readies_url
    click_on "New ready"

    click_on "Create Ready"

    assert_text "Ready was successfully created"
    click_on "Back"
  end

  test "should update Ready" do
    visit ready_url(@ready)
    click_on "Edit this ready", match: :first

    click_on "Update Ready"

    assert_text "Ready was successfully updated"
    click_on "Back"
  end

  test "should destroy Ready" do
    visit ready_url(@ready)
    click_on "Destroy this ready", match: :first

    assert_text "Ready was successfully destroyed"
  end
end
