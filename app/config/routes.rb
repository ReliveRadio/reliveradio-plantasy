require 'sidekiq/web'

App::Application.routes.draw do

  root to: 'podcasts#index'

  get "/directory", to: 'directory#index'
  get "/directory/show_podcast/:id", to: 'directory#show_podcast', as: 'directory_show_podcast'
  get "/directory/show_episode/:id", to: 'directory#show_episode', as: 'directory_show_episode'

  devise_for :admins
  resources :admins, only: [:index, :destroy]
  get 'admins/:id/approve', to: 'admins#approve', as: 'approve_user'

  resources :channel_playlists do
    resources :playlist_entries
  end

  get 'playlist_management/:channel_playlist', to: 'playlist_management#index', as: 'playlist_management'
  get 'playlist_management/:channel_playlist/create_entry/:episode_id', to: 'playlist_management#create_entry'
  get 'playlist_management/:channel_playlist/destroy_entry/:playlist_entry_id', to: 'playlist_management#destroy_entry'
  post 'playlist_management/:channel_playlist/sort', to: 'playlist_management#sort' , as: 'sort_playlist_entries'

  get '/podcasts/:id/update', to: 'podcasts#update_feed'
  get '/podcasts/update_all', to: 'podcasts#update_all_feeds'
  get '/podcasts/delete_all_episodes', to: 'podcasts#delete_all_episodes'
  get '/podcasts/download_all_episodes', to: 'podcasts#download_all_episodes'
  resources :podcasts

  get '/episodes/:id/download', to: 'episodes#download'
  get '/episodes/:id/play', to: 'episodes#play'
  get '/episodes/:id/delete_cached_file', to: 'episodes#delete_cached_file'
  resources :episodes
  

  authenticate :admin do
    mount Sidekiq::Web => '/sidekiq'
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
