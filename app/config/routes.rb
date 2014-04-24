require 'sidekiq/web'

App::Application.routes.draw do

  root to: 'schedule#index'

  resources :jingles

  get "channel/", to: 'schedule#index', as: 'schedule'
  get "channel/:channel_playlist_id/show", to: 'schedule#show', as: 'schedule_show'

  get "/directory", to: 'directory#index'
  get "/directory/show_podcast/:id", to: 'directory#show_podcast', as: 'directory_show_podcast'
  get "/directory/show_episode/:id", to: 'directory#show_episode', as: 'directory_show_episode'

  devise_for :admins
  resources :admins, only: [:index, :destroy]
  get 'admins/:id/approve', to: 'admins#approve', as: 'approve_user'

  resources :channel_playlists

  get "playlist_management/:channel_playlist_id", to: "playlist_management#index", as: 'playlist_management'
  get 'playlist_management/:channel_playlist_id/append_episode/:episode_id', to: 'playlist_management#append_entry'
  get 'playlist_management/:channel_playlist_id/append_jingle/:jingle_id', to: 'playlist_management#append_entry'
  get 'playlist_management/:channel_playlist_id/destroy_entry/:playlist_entry_id', to: 'playlist_management#destroy_entry'
  post 'playlist_management/:channel_playlist_id/sort', to: 'playlist_management#sort' , as: 'sort_playlist_entries'
  get 'playlist_management/:channel_playlist_id/update_playlist', to: 'playlist_management#update_playlist' , as: 'update_playlist_entries'

  # shallow routing:
  # resources :posts do
  #   resources :comments, only: [:index, :new, :create]
  # end
  # resources :comments, only: [:show, :edit, :update, :destroy]

  resources :podcasts do 
    get 'update_feed', on: :member
    get 'delete_all_episodes', on: :member
    get 'download_all_episodes', on: :member
    get 'update_all_feeds', on: :collection
    resources :episodes, except: :index, shallow: true do
      get 'download', on: :member
      get 'delete_cached_file', on: :member
    end
  end

  authenticate :admin do
    mount Sidekiq::Web => '/sidekiq', as: 'sidekiq'
  end

end
