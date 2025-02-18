Rails.application.routes.draw do
  resource :session, only: [:new, :create, :destroy]
  resources :passwords, param: :token, only: [:new, :create, :edit, :update]
  resources :users, only: [:new, :create]

  get "up" => "rails/health#show", as: :rails_health_check

  root "books#index"

  # Fix: Single `resources :books` block
  resources :books, only: [:index, :show] do
    member do
      post 'borrow'
      patch 'return', to: 'books#return_book', as: 'return_book'
    end
  end

  get 'profile', to: 'users#profile'

  resources :borrowings, only: [:update]

  resource :user, only: [:show]
  
  delete "/logout", to: "sessions#destroy"
end
