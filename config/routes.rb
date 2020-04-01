Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get 'about', to: 'pages#about'
  get 'results', to: 'pages#results'
  get 'fetch_home', to: 'pages#fetch_for_homepage'
  get 'fetch_results', to: 'pages#fetch_for_results_page'
  post 'fetch_results', to: 'pages#fetch_for_results_page'
  get 'fetch_portuguese_cities', to: 'pages#fetch_portuguese_cities'
  get 'fetch_england_cities', to: 'pages#fetch_england_cities'
  get 'fetch_american_states', to: 'pages#fetch_american_states'
  get 'fetch_french_cities', to: 'pages#fetch_french_cities'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
