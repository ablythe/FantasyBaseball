Rails.application.routes.draw do
  devise_for :users
  
  root 'welcome#index'

  resources :tracker, only: [:show, :update]
  resources :rosters
end
