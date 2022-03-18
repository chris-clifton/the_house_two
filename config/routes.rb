Rails.application.routes.draw do
  # Routes for users
  devise_for :users
  resources :users, only: [:index, :show], param: :slug

  resources :chores

  resources :assigned_chores do
    put 'mark_complete'
  end

  resources :consequences

  resources :consequence_types

  root "home#index"
end
