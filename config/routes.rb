Rails.application.routes.draw do
  # Authentication routes
  resource :session, only: [:new, :create, :destroy] # Handles login/logout
  resources :passwords, param: :token, only: [:new, :create, :edit, :update]
  resources :users, only: [:new, :create]

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # Set the homepage to the books index page
  root "books#index"

  # Book routes
  resources :books, only: [:index, :show] do
    resources :borrowings, only: [:create] # Borrowing books
  end

  # Borrowing routes (for returning books)
  resources :borrowings, only: [:update]

  # User profile route
  resource :user, only: [:show] # Shows the current user's profile and borrowed books

  # Logout route
  delete "/logout", to: "sessions#destroy"
end
