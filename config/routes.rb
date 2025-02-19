Rails.application.routes.draw do
  resource :session, only: [:new, :create, :destroy]
  resources :passwords, param: :token, only: [:new, :create, :edit, :update]
  resources :users, only: [:new, :create]

  get "up" => "rails/health#show", as: :rails_health_check

  root "books#index"

  resources :books, only: [:index, :show] do
    member do
      post 'borrow', to: 'books#borrow'
      patch 'return', to: 'books#return_book', as: 'return_book'
    end

    # Nest BorrowingsController routes under books.
    resources :borrowings, only: [:create] do
      collection do
        patch 'return_book', to: 'borrowings#return_book'
      end
    end
  end

  get 'profile', to: 'users#profile'
  
  delete "/logout", to: "sessions#destroy"
end
