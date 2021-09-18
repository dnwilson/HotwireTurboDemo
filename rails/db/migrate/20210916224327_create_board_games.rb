class CreateBoardGames < ActiveRecord::Migration[6.1]
  def change
    create_table :board_games do |t|
      t.string :name
      t.integer :players

      t.timestamps
    end
  end
end
