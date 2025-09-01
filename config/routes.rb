Rails.application.routes.draw do
  root 'rankings#index'

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :users, only: [:show]

  # Health check route
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Movie routes with nested schedules and reservations
  resources :reservations, only: %i[create destroy edit update]
  resources :schedules, only: [:index] # スケジュールの取得用にindexアクションを設定
  resources :sheets do
    collection do
      get 'available' # 利用可能な座席を取得するためのルート
    end
  end
  resources :movies do
    get 'schedules', on: :member
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
      resources :schedules, only: %i[new create]
    end
    resources :schedules, only: %i[index show edit update destroy]
    resources :theaters do
      get 'screens', on: :member
    end
    resources :screens do
      member do
        get 'sheets'
      end
    end
  end

  # Sheets route
  resources :sheets, only: [:index]
end
