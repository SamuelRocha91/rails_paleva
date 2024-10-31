Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  get 'search', to: 'search#search'

  resources :establishments, only: [:new, :create, :edit, :update] do
    resources :dishes, only: [:new, :create, :index]
    resources :beverages, only: [:index, :new, :create]
  end

  resources :dishes, only: [:edit, :update, :show, :destroy] do
    post 'deactivate', on: :member
    post 'activate', on: :member
    get 'offer', on: :member
    post 'offer', on: :member, to: 'dishes#create_offer'    
  end

  resources :beverages, only: [:new, :create, :index] do
    post 'deactivate', on: :member
    post 'activate', on: :member
  end
end
