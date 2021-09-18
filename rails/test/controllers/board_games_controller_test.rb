require "test_helper"

class BoardGamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @board_game = board_games(:one)
  end

  test "should get index" do
    get board_games_url
    assert_response :success
  end

  test "should get new" do
    get new_board_game_url
    assert_response :success
  end

  test "should create board_game" do
    assert_difference('BoardGame.count') do
      post board_games_url, params: { board_game: { name: @board_game.name, players: @board_game.players } }
    end

    assert_redirected_to board_game_url(BoardGame.last)
  end

  test "should show board_game" do
    get board_game_url(@board_game)
    assert_response :success
  end

  test "should get edit" do
    get edit_board_game_url(@board_game)
    assert_response :success
  end

  test "should update board_game" do
    patch board_game_url(@board_game), params: { board_game: { name: @board_game.name, players: @board_game.players } }
    assert_redirected_to board_game_url(@board_game)
  end

  test "should destroy board_game" do
    assert_difference('BoardGame.count', -1) do
      delete board_game_url(@board_game)
    end

    assert_redirected_to board_games_url
  end
end
