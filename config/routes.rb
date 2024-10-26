Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  resources :establishments, only: [:new, :create, :edit, :update] do
    resources :dishes, only: [:new, :create, :index, :edit, :update, :show, :destroy]
    resources :beverages, only: [:index, :new, :create, :show, :edit, :update, :destroy]
  end
end
