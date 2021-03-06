class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: { user: current_user.to_json }
  end
end