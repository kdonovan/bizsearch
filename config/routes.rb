Rails.application.routes.draw do
  root to: 'visitors#index'
  get 'saved_searches', to: 'visitors#saved_searches'
  get 'listings', to: 'listings#index'
  post '/listings/refresh', to: 'listings#refresh', as: 'run_searches'
  post '/listings/:id/decide/:action', to: 'listings#decide', as: 'decide_on_listing'

  resources :listings do
    resources :notes
  end
end
