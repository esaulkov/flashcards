Rails.application.routes.draw do
  root "dashboard/reviews#new"

  namespace :dashboard do
    root "reviews#new"
    resources :cards
    resources :reviews, only: [:new, :create]

    resources :decks do
      put "set_current", on: :member
    end
    resource :profile, only: [:edit, :update]

    delete "log_out", to: "sessions#destroy", as: :log_out
    delete "oauth/:provider", to: "oauths#destroy", as: :delete_oauth
  end

  namespace :home do
    root "sessions#new"
    resources :registrations, only: [:new, :create]
    get "/sign_up", to: "registrations#new", as: :sign_up

    resources :reset_passwords, only: [:new, :create, :edit, :update]
    resources :sessions, only: [:new, :create]
    get "/log_in", to: "sessions#new", as: :log_in

    get "oauth/callback", to: "oauths#callback"
    post "oauth/callback", to: "oauths#callback"
    get "oauth/:provider", to: "oauths#oauth", as: :auth_at_provider
  end
end
