Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]

  as :user do
    get 'users/new', to: 'devise/registrations#new', as: :new_user_registration
    post 'users', to: 'devise/registrations#create', as: :user_registration
  end

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # Movie routes with nested schedules and reservations
  resources :reservations, only: [:create]
  resources :movies do
    resources :schedules do
      resources :reservations, only: [:new]
    end
    member do
      get 'reservation', to: 'movies#reservation'
    end
  end

  # Admin routes
  namespace :admin do
    resources :reservations, except: [:edit]
    resources :movies do
      resources :schedules, only: [:new, :create]
    end
    resources :schedules, only: [:index, :show, :edit, :update, :destroy]
  end

  # Sheets route
  resources :sheets, only: [:index]
end