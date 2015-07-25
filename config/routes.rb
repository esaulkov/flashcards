Rails.application.routes.draw do
  root "reviews#new"

  resources :cards
  resources :reviews, only: [:new, :create]
end
