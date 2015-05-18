Rails.application.routes.draw do
  devise_for :users
  
  root 'players#index'
  resources :search, only: [:index], path: 'players/search'
  resources :players, only: [:show, :index] 


  resources :rosters, only: [:index, :show, :update]
end
