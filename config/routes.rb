Rails.application.routes.draw do
  
  resources :users
  resources :ratings
  
  resources :reviews do
    resources :ratings
  end

  resources :users do
    resources :ratings
  end
  
  get '/logout' => 'users#logout'
  get "login", :to => "users#login"
  get '/register', :to => "users#new"
  get "login_attempt", :to => "users#login_attempt"
  post "login_attempt", :to => "users#login_attempt"
  post 'reviews/search_by_place'
  
  get 'update_user_location', :to => 'users#update_user_location'

  get 'api/show_reviews'
  get 'api/show_ratings'
  get 'api/get_user_by_rating'

  root 'reviews#index'
end
