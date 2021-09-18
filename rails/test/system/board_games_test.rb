require "application_system_test_case"

class BoardGamesTest < ApplicationSystemTestCase
  setup do
    @board_game = board_games(:one)
  end

  test "visiting the index" do
    visit board_games_url
    assert_selector "h1", text: "Board Games"
  end

  test "creating a Board game" do
    visit board_games_url
    click_on "New Board Game"

    fill_in "Name", with: @board_game.name
    fill_in "Players", with: @board_game.players
    click_on "Create Board game"

    assert_text "Board game was successfully created"
    click_on "Back"
  end

  test "updating a Board game" do
    visit board_games_url
    click_on "Edit", match: :first

    fill_in "Name", with: @board_game.name
    fill_in "Players", with: @board_game.players
    click_on "Update Board game"

    assert_text "Board game was successfully updated"
    click_on "Back"
  end

  test "destroying a Board game" do
    visit board_games_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Board game was successfully destroyed"
  end
end
