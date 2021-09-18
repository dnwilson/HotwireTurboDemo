class API::ApplicationController < ApplicationController
  skip_before_action :verify_authenticity_token

  respond_to :json

  protected

  def authenticate_api_user!
    if (user = api_user)
      sign_in(user, store: false)
    else
      head :unauthorized
    end
  end

  private

  def api_user
    token = request.headers.fetch("Authorization", "").split(" ").last
    User.find_by(access_token: token) if token.present?
  end
end