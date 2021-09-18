Rails.application.routes.draw do
  devise_for :users

  resources :board_games
  resources :notification_tokens, only: :create
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    resource :auth, only: :create, controller: "auth"
    get "/turbo", to: "turbo#show"
  end

  get "/me", to: "users#show"

  root "board_games#index"
end
