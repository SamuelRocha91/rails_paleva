Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  get 'search', to: 'search#search'
  resources :establishments, only: [:new, :create, :edit, :update] do
    resources :dishes, only: [:new, :create, :index, :edit, :update, :show, :destroy] do
      post 'deactivate', on: :member
      post 'activate', on: :member
    end
    resources :beverages, only: [:index, :new, :create, :show, :edit, :update, :destroy]
  end
end
