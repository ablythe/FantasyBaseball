Rails.application.routes.draw do
  devise_for :users
  
  root 'application#index'
  resources :search, only: [:index], path: 'players/search'
  resources :players, only: [:show, :index] 


  resources :rosters, only: [:index, :show, :update]
end
