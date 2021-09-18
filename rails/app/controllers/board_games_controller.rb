class BoardGamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_board_game, only: %i[ show edit update destroy ]

  # GET /board_games or /board_games.json
  def index
    @board_games = BoardGame.all
  end

  # GET /board_games/1 or /board_games/1.json
  def show
  end

  # GET /board_games/new
  def new
    @board_game = BoardGame.new
  end

  # GET /board_games/1/edit
  def edit
  end

  # POST /board_games or /board_games.json
  def create
    @board_game = BoardGame.new(board_game_params)

    respond_to do |format|
      if @board_game.save
        format.html { redirect_to @board_game, notice: "Board game was successfully created." }
        format.json { render :show, status: :created, location: @board_game }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @board_game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /board_games/1 or /board_games/1.json
  def update
    respond_to do |format|
      if @board_game.update(board_game_params)
        format.html { redirect_to @board_game, notice: "Board game was successfully updated." }
        format.json { render :show, status: :ok, location: @board_game }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @board_game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /board_games/1 or /board_games/1.json
  def destroy
    @board_game.destroy
    respond_to do |format|
      format.html { redirect_to board_games_url, notice: "Board game was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_board_game
      @board_game = BoardGame.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def board_game_params
      params.require(:board_game).permit(:name, :players)
    end
end
