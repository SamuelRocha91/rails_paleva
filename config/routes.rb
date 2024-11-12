Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    namespace :v1 do
      resources :establishment, only: [], param: :code do
        get '/orders', to: 'establishments#list_orders', on: :member
      end
    end
  end

  root "home#index"

  get 'search', to: 'search#search'

  get 'orders/preview', to: 'orders#preview_order', as: 'preview_order'

  resources :establishments, only: [:index, :new, :create, :edit, :update] do
    get 'user/new', on: :member, to: 'establishments#form_registration_user'
    post 'user/new', on: :member, to: 'establishments#pre_registration_user'

    resources :dishes, only: [:new, :create, :index, :edit, :update, :show]
  
    resources :beverages, only: [:index, :new, :create, :edit, :update, :show]
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
      post 'offer/:offer_id/deactivate', to: 'beverages#deactivate_offer', as: 'deactivate_offer'
    end
  end

  resources :tags, only: [:index, :create, :new]

  resources :menus, only: [:new, :create, :show] do
    resources :menu_items, only: [:new, :create]
  end

  resources :orders, only: [:new, :create, :show, :index] do
    get 'offer/new', on: :member, to: 'orders#new_offer'
  end

  resources :orders, only: [] do
    get 'add_item/:portion_id', to: 'orders#new_item', as: 'new_item_to_order', on: :collection
    post 'add_item/:portion_id', to: 'orders#add_item', as: 'add_item_to_order', on: :collection
    post 'canceled', on: :member
    post 'in-preparation', on: :member
    post 'ready', on: :member
    post 'delivered', on: :member
  end

end
