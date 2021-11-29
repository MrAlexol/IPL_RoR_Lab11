require "application_system_test_case"

class SequencesTest < ApplicationSystemTestCase
  setup do
    @sequence = sequences(:one)
  end

  test "visiting the index" do
    visit sequences_url
    assert_selector "h1", text: "Sequences"
  end

  test "creating a Sequence" do
    visit sequences_url
    click_on "New Sequence"

    fill_in "Output", with: @sequence.output
    fill_in "Values", with: @sequence.values
    click_on "Create Sequence"

    assert_text "Sequence was successfully created"
    click_on "Back"
  end

  test "updating a Sequence" do
    visit sequences_url
    click_on "Edit", match: :first

    fill_in "Output", with: @sequence.output
    fill_in "Values", with: @sequence.values
    click_on "Update Sequence"

    assert_text "Sequence was successfully updated"
    click_on "Back"
  end

  test "destroying a Sequence" do
    visit sequences_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Sequence was successfully destroyed"
  end
end
