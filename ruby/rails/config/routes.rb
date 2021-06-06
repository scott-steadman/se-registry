Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

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
      get :home # bounce uers to their home page
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

end
