Rails.application.routes.draw do
  root "welcome#index"

  resources :cards, only: :index
end
