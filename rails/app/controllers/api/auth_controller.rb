class API::AuthController < API::ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user&.valid_password?(params[:password])
      user.remember_me = true
      sign_in(user)
      render json: { token: user.access_token }
    else
      render :unauthorized
    end
  end
end