json.extract! board_game, :id, :name, :players, :created_at, :updated_at
json.url board_game_url(board_game, format: :json)
