class ApplicationController < ActionController::Base

  protected
  # redirecting to appropriate url based on role
  def after_sign_in_path_for(resource)
    root_path
  end
end
