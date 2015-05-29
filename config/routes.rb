Rails.application.routes.draw do
  devise_for :users
  
  root 'players#index'
  resources :search, only: [:new, :create, :index], path: 'players/search'
  resources :players, only: [:show, :index] do
    member do
      get "claim"
    end
  end


  resources :rosters, only: [:index, :show, :update]
    
end
