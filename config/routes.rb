Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  root "static_pages#top"
  get "policy", to: "static_pages#policy"
  get "terms", to: "static_pages#terms"
  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"
  post "oauth/callback", to: "oauths#callback"
  get "oauth/callback", to: "oauths#callback"
  get "oauth/:provider", to: "oauths#oauth", as: :auth_at_provider
  # Googleログインで使用する Oauthルーディング

  resources :user_sessions, only: %i[new create destroy]
  resources :users do
    resources :posts, only: %i[index]
    resources :likes, only: %i[index]
    member do
      delete "destroy_avatar"
    end
  end
  resources :posts do
    resources :likes, only: %i[create destroy]
    resources :comments, only: %i[create edit update destroy], shallow: true do
      member do
        get "edit_cancel"
      end
      collection do
        get "replace_all_comments"
      end
    end
  end
  resources :tags, only: %i[index] do
    collection do
      get "replace_area_tags"
      get "replace_genre_tags"
      get "replace_taste_tags"
      get "replace_outher_tags"
    end
  end
  resources :searchs, only: %i[index] do
    collection do
      get "search_by_form"
      get "autocomplete"
    end
  end
  resources :view_histories, only: %i[index] do
    collection do
      delete "all_view_history_delete"
    end
  end
  resources :password_resets, only: %i[new create edit update]

  namespace :admin do
    resources :users, only: %i[index edit update destroy]
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
