Registry::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

  match '/about'    => 'users#about',           :as => :about
  match '/friends'  => 'friends#index',         :as => :friends
  match '/home'     => 'gifts#index',           :as => :home
  match '/login'    => 'user_sessions#new',     :as => :login
  match '/logout'   => 'user_sessions#destroy', :as => :logout
  match '/settings' => 'users#edit',            :as => :settings

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

  root :to => 'gifts#index'

  match '/:controller(/:action(/:id))(.:format)'
end
