Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  root "static_pages#top"
  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"
  resources :user_sessions, only: %i[new create destroy]
  resources :users do
    resources :posts, only: %i[index]
    resources :playlists, only: %i[index]
    resources :likes, only: %i[index]
    member do
      delete "destroy_avatar"
    end
    collection do
      delete "aws_test_delete"
    end
    get :search, on: :collection
  end
  resources :posts do
    member do
      post "add_to_playlist"
    end
    resources :likes, only: %i[create destroy]
    resources :comments, only: %i[create edit update destroy], shallow: true do
      member do
        get "edit_cancel"
      end
      collection do
        get "replace_all_comments"
      end
    end
# ------------------------------
    collection do
      get "index_test"
      get "search"
      
    end
    get :autocomplete, on: :collection
    # ------------------------------
  end
  resources :tags, only: %i[index] do
    collection do
      get "replace_area_tags"
      get "replace_genre_tags"
      get "replace_taste_tags"
      get "replace_outher_tags"
    end
  end
  resources :searchs, only: %i[index]
  resources :playlists do
    resources :posts, only: %i[show]
    member do
      delete "remove_playlist"
    end
  end
  resources :view_histories, only: %i[index] do
    collection do
      delete "all_view_history_delete"
    end
  end
  resources :password_resets, only: %i[new create edit update]

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
