Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  resources :establishments, only: [:new, :create, :edit, :update]
end
