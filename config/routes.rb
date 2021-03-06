require 'sidekiq/web'

Rails.application.routes.draw do
  root 'static_pages#root'

  get 'about' => 'static_pages#about', as: :about
  get 'badge' => 'static_pages#badge', as: :badge

  constraints Shard::DocsController::CONSTRAINTS do
    get ':hosting/:owner/:name' => 'shard/docs#repository', as: :repository
    get ':hosting/:owner/:name/:sha' => 'shard/docs#show', as: :sha
    get ':hosting/:owner/:name/:sha/:file' => 'shard/docs#file_serve', as: :doc_serve
    post ':hosting/:owner/:name/:sha/retry' => 'shard/docs#retry', as: :retry
  end

  get 'search' => 'search#show', as: :search
  get 'opensearch' => 'search#opensearch', as: :opensearch, format: 'xml'

  get 'status' => 'static_pages#status', as: :status

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

  mount Sidekiq::Web => '/sidekiq' if Rails.env.development?
end
