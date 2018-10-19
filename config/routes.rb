Rails.application.routes.draw do
  root 'breweries#index'

  resources :styles
  resources :beers
  resources :beer_clubs
  resources :memberships
  resources :ratings, only: [:index, :new, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]
  
  resources :users do
    post 'toggle_closed', on: :member
  end

  resources :breweries do
    post 'toggle_activity', on: :member
  end

  resources :places, only: [:index, :show]
  post 'places', to:'places#search'
  
  get 'signin', to: 'sessions#new'
  get 'signup', to: 'users#new'
  delete 'signout', to: 'sessions#destroy'

end

