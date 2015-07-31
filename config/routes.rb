Rails.application.routes.draw do
  root "reviews#new"

  resources :cards
  resources :reviews, only: [:new, :create]

  resources :users, only: [:new, :create, :edit, :update]
  get "/sign_up", to: "users#new", as: :sign_up
  get "/profile", to: "users#edit", as: :profile

  resources :sessions, only: [:new, :create, :destroy]
  get "/log_in", to: "sessions#new", as: :log_in
  delete "log_out", to: "sessions#destroy", as: :log_out

  resources :reset_passwords, only: [:new, :create, :edit, :update]
end
