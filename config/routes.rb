Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get 'about', to: 'pages#about'
  get 'results', to: 'pages#results'
  get 'fetch_home', to: 'pages#fetch_for_homepage'
  get 'fetch_results', to: 'pages#fetch_for_results_page'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
