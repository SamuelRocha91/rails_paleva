Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  get 'search', to: 'search#search'

  resources :establishments, only: [:new, :create, :edit, :update] do
    resources :dishes, only: [:new, :create, :index, :edit, :update, :show, :destroy]
    resources :beverages, only: [:index, :new, :create, :edit, :update, :show, :destroy]
  end

  resources :dishes, only: [] do
    member do
      post 'deactivate'
      post 'activate'
      get 'offer'
      post 'offer', to: 'dishes#create_offer'
      get 'offer/:offer_id/edit', to: 'dishes#edit_offer', as: 'edit_offer'
      post 'offer/:offer_id/update', to: 'dishes#update_offer', as: 'update_offer'
      post 'offer/:offer_id/deactivate', to: 'dishes#deactivate_offer', as: 'deactivate_offer'
    end   
  end

  resources :beverages, only: [] do
    member do
      post 'deactivate'
      post 'activate'
      get 'offer'
      post 'offer', to: 'beverages#create_offer'
      get 'offer/:offer_id/edit', to: 'beverages#edit_offer', as: 'edit_offer'
      post 'offer/:offer_id/update', to: 'beverages#update_offer', as: 'update_offer'
    end
  end
end
