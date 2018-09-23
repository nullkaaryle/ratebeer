Rails.application.routes.draw do
  root 'breweries#index'
  resource :session, only: [:new, :create, :destroy]
  resources :beers
  resources :breweries
  resources :ratings, only: [:index, :new, :create, :destroy]
  resources :users
  get 'signup', to: 'users#new'
end

