Rails.application.routes.draw do
  devise_for :users

  resources :chores
  resources :assigned_chores
  resources :consequences
  resources :consequence_types

  root "home#index"
end
