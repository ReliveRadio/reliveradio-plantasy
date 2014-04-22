require 'sidekiq/web'

App::Application.routes.draw do

  root to: 'schedule#index'

  resources :jingles

  get "channel/", to: 'schedule#index', as: 'schedule'
  get "channel/:channel_playlist/show", to: 'schedule#show', as: 'schedule_show'

  get "/directory", to: 'directory#index'
  get "/directory/show_podcast/:id", to: 'directory#show_podcast', as: 'directory_show_podcast'
  get "/directory/show_episode/:id", to: 'directory#show_episode', as: 'directory_show_episode'

  devise_for :admins
  resources :admins, only: [:index, :destroy]
  get 'admins/:id/approve', to: 'admins#approve', as: 'approve_user'

  resources :channel_playlists do
    resources :playlist_entries, shallow: true
  end

  get "playlist_management/:channel_playlist", to: "playlist_management#index", as: 'playlist_management'
  get 'playlist_management/:channel_playlist/append_episode/:episode_id', to: 'playlist_management#append_entry'
  get 'playlist_management/:channel_playlist/append_jingle/:jingle_id', to: 'playlist_management#append_entry'
  get 'playlist_management/:channel_playlist/destroy_entry/:playlist_entry_id', to: 'playlist_management#destroy_entry'
  post 'playlist_management/:channel_playlist/sort', to: 'playlist_management#sort' , as: 'sort_playlist_entries'
  get 'playlist_management/:channel_playlist/update_playlist', to: 'playlist_management#update_playlist' , as: 'update_playlist_entries'

  get '/podcasts/:id/update', to: 'podcasts#update_feed'
  get '/podcasts/update_all', to: 'podcasts#update_all_feeds'
  get '/podcasts/delete_all_episodes', to: 'podcasts#delete_all_episodes'
  get '/podcasts/download_all_episodes', to: 'podcasts#download_all_episodes'
  resources :podcasts

  get '/episodes/:id/download', to: 'episodes#download'
  get '/episodes/:id/delete_cached_file', to: 'episodes#delete_cached_file'
  resources :episodes
  

  authenticate :admin do
    mount Sidekiq::Web => '/sidekiq', as: 'sidekiq'
  end

end
