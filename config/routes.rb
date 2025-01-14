require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations:  'users/registrations',
    sessions:      'users/sessions'
  }

  mount Sidekiq::Web => "/sidekiq"
  mount Myapp::Base => "/"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  resources :keywords, only: [:index, :create, :show, :destroy]

  # Defines the root path route ("/")
  root "home#show"
end
