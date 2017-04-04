Myflix::Application.routes.draw do
  root 'static_pages#root'
  
  get 'ui(/:action)', controller: 'ui'
  
  get '/home', to: 'videos#index'
  
  resources :videos, only: [:show] do 
    resources :reviews, only: [:create]
    
    collection do 
      get '/search', to: 'videos#search'
    end
  end
  
  resources :categories, only: [:show], param: :name
  
  get '/my_queue', to: 'queue_items#index'
  post 'my_queue', to: 'queue_items#create'
  post 'update_queue', to: 'queue_items#update_queue'
  delete 'my_queue', to: 'queue_items#destroy'
  
  
  
  get 'register', to: 'users#new'
  resources :users, only: [:create, :show]
  get 'people', to: 'relationships#index'
  resources :relationships, only: [:create, :destroy]
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'forgot_password', to: 'forgot_passwords#new'
  resources :forgot_passwords, only: [:create]
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'
  
  resources :password_resets, only: [:show, :create]
  get 'expired_token', to: 'password_resets#expired_token'
  
end
