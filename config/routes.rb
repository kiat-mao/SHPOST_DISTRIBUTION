ShpostDistribution::Application.routes.draw do
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
  root 'welcome#index'

  devise_for :users, controllers: { sessions: "users/sessions" }

  resources :user_logs, only: [:index, :show, :destroy]

  resources :units do
    resources :users, :controller => 'unit_users'
  end

  resources :users do
    member do
      get 'to_reset_pwd'
      patch 'reset_pwd'
    end
    resources :roles, :controller => 'user_roles'
  end

  resources :up_downloads do
    collection do 
      get 'up_download_import'
      post 'up_download_import' => 'up_downloads#up_download_import'
      
      get 'to_import'
      
      
    end
    member do
      get 'up_download_export'
      post 'up_download_export' => 'up_downloads#up_download_export'
    end
  end

  resources :import_files do
    collection do
      get 'image_index'
    end
    
    member do 
      get 'download'
      post 'download' => 'import_files#download'
    end
  end

  resources :suppliers do
    collection do 
      get 'supplier_import'
      post 'supplier_import' => 'suppliers#supplier_import'
      
    end

    member do
      get 'set_valid'
      get 'contracts_upload'
      post 'contracts_upload' => 'suppliers#contracts_upload'
      get 'contracts_show'
    end
  end

  resources :commodities do
    collection do 
      get 'commodity_import'
      post 'commodity_import' => 'commodities#commodity_import'
    end

    member do
      get 'cover_upload'
      post 'cover_upload' => 'commodities#cover_upload'
      get 'set_on_sell'
    end
  end

  resources :supplier_autocom do
    collection do
      get 'c_autocomplete_supplier_name'
        
    end
  end

  resources :orders do
    collection do
      get 'fresh' => 'orders#fresh'
      get 'pending' => 'orders#pending'
      get 'checking' => 'orders#checking'
      get 'declined' => 'orders#declined'
      get 'rechecking' => 'orders#rechecking'
      get 'receiving' => 'orders#receiving'
    end
    resources :order_details
  end

  get 'order_details' => 'order_details#index'


  
end
