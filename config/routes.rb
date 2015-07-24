Rails.application.routes.draw do
  root "cards#random"

  resources :cards do
    get "random", on: :collection
    patch "check", on: :member
  end
end
