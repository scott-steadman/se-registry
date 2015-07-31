Rails.application.routes.draw do
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

  root 'gifts#index'

  get '/about'          => 'users#about',               :as => :about
  get '/clear_cookies'  => 'user_sessions#clear_cookies'                # Issue 110
  get '/friends'        => 'friends#index',             :as => :friends
  get '/home'           => 'gifts#index',               :as => :home
  get '/login'          => 'user_sessions#new',         :as => :login
  get '/logout'         => 'user_sessions#destroy',     :as => :logout
  get '/settings'       => 'users#edit',                :as => :settings

  resource :user_session

  resources :events
  resources :gifts
  resources :occasions, :controller => :events
  resources :reminders, :controller => :events

  resources :users do
    resources :events
    resources :friends

    resources :gifts do
      member do
        post :will
        delete :wont
      end
    end

    resources :occasions, :controller => :events
    resources :reminders, :controller => :events
  end

  get '/:controller(/:action(/:id))(.:format)'

end
