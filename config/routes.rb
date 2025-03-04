Rails.application.routes.draw do
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
  end
  resources :posts do
    member do
      post "add_to_playlist"
    end
    resources :likes, only: %i[create destroy]
    resources :comments, only: %i[create edit destroy], shallow: true
  end
  resources :tags, only: %i[index] do
    collection do
      get "replace_area_tags"
    end
  end
  resources :searchs, only: %i[index]
  resources :playlists do
    resources :posts, only: %i[show]
    member do
      delete "remove_playlist"
    end
  end
  resources :comments, only: %i[edit update]
  resources :view_histories, only: %i[index] do
    collection do
      delete "all_view_history_delete"
    end
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
