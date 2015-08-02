Rails.application.routes.draw do
  root "reviews#new"

  resources :cards
  resources :reviews, only: [:new, :create]

  resources :registrations, only: [:new, :create]
  get "/sign_up", to: "registrations#new", as: :sign_up
  resource :profile, only: [:edit, :update]

  resources :sessions, only: [:new, :create, :destroy]
  get "/log_in", to: "sessions#new", as: :log_in
  delete "log_out", to: "sessions#destroy", as: :log_out

  resources :reset_passwords, only: [:new, :create, :edit, :update]
  get "oauth/callback", to: "oauths#callback"
  post "oauth/callback", to: "oauths#callback"
  get "oauth/:provider", to: "oauths#oauth", as: :auth_at_provider
  delete "oauth/:provider", to: "oauths#destroy", as: :delete_oauth
end
