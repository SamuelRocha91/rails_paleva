Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  resources :establishments, only: [:new, :create, :edit, :update] do
    resources :dishes, only: [:new, :create, :index]
  end
end
