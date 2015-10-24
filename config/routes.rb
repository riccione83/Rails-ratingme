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
  post 'api/new_review'
  
  get 'api/show_ratings'
  post 'api/new_rating'
  
  get 'api/get_user_by_rating'
  get 'api/login_user'
  get 'api/register_new_user'
  
  get 'api/login_with_social'

  root 'reviews#index'
end
