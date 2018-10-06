Rails.application.routes.draw do
  resources :beers
  resources :beer_clubs
  resources :breweries
  resources :memberships
  resources :ratings, only: [:index, :new, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]
  resources :users

  get 'places', to: 'places#index'
  post 'places', to:'places#search'
  
  get 'signin', to: 'sessions#new'
  get 'signup', to: 'users#new'
  delete 'signout', to: 'sessions#destroy'

  root 'breweries#index'
end

