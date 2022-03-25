Rails.application.routes.draw do
  # Routes for members
  devise_for :members
  resources :members, only: [:index, :show], param: :slug

  resources :tasks

  resources :assignments do
    put 'mark_pending_review'
    put 'mark_in_progress'
    put 'mark_complete'
    put 'mark_failed'
  end

  resources :consequences

  resources :consequence_types

  root "home#index"
end
