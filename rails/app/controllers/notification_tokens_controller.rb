class NotificationTokensController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def create
    current_user.notification_tokens.find_or_create_by!(token: params[:token])
    head :ok
  end
end