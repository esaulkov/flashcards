Rails.application.routes.draw do
  root "reviews#new"

  resources :cards
  resources :reviews, only: [:new, :create]
  resources :users, only: [:new, :create]
  get "/sign_up", to: "users#new", as: :sign_up
  resources :sessions, only: [:new, :create, :destroy]
  get "/log_in", to: "sessions#new", as: :log_in
  get "log_out", to: "sessions#destroy", as: :log_out
end
