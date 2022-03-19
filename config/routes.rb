Rails.application.routes.draw do
  # Routes for users
  devise_for :users
  resources :users, only: [:index, :show], param: :slug

  resources :tasks

  resources :assignments do
    put 'mark_complete'
  end

  resources :consequences

  resources :consequence_types

  root "home#index"
end
