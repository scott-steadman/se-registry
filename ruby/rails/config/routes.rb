Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Issue 31
  mount ActionCable.server => '/cable'

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

  resources :friends do
    collection do
      get :export
    end
  end

  resources :gifts
  resources :occasions, :controller => 'events/occasions'
  resources :reminders, :controller => 'events/reminders'

  # allow users to upadte themselves
  patch '/users(/:id)(.:format)', :to => 'users#update'

  # allow users to close their own accounts
  delete '/users(/:id)(.:format)', :to => 'users#destroy'

  resources :users do

    collection do
      get :autocomplete
    end

    resources :events
    resources :friends

    resources :gifts do
      member do
        post :will
        delete :wont
      end
    end

    resources :occasions, :controller => 'events/occasions'
    resources :reminders, :controller => 'events/reminders'
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end