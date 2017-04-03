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
  resources :users, only: [:create]
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
end
