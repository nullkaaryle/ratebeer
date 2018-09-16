Rails.application.routes.draw do
  root 'breweries#index'
  resources :beers
  resources :breweries
  resources :ratings
  get 'ratings', to: 'ratings#index'
  get 'ratings/new', to:'ratings#new'
  post 'ratings', to: 'ratings#create'
  # get 'kaikki_bisset', to: 'beers#index'
  # get( 'kaikki_bisset', { :to => 'beers#index' } )

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

