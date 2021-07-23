Rails.application.routes.draw do
  resources :sessions, only: [:new, :create, :destroy]
  resources :tasks
  resources :users, only: [:new, :create, :show]
  root to: 'tasks#index'
  namespace :admin do
      resources :users, only: [:index, :show, :new, :create, :destroy, :edit, :update]
      resources :tags
      end
end
