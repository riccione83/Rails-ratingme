Rails.application.routes.draw do
  
  get 'welcome/home'

  post '/rate' => 'rater#create', :as => 'rate'
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
  get 'forgot_password', :to => "application#forgot_password"
  get 'cookies_policy', :to => "application#cookies_policy"
  get 'privacy_policy', :to => "application#privacy_policy"
  get 'user_agreement', :to => "application#user_agreement"
  post "login_attempt", :to => "users#login_attempt"
  post 'reviews/search_by_place'
  
  get 'update_user_location', :to => 'users#update_user_location'
  get 'update_user_radius', :to => 'users#update_user_radius'

  get 'api/show_reviews'
  post 'api/new_review'
  
  get 'api/show_ratings'
  get 'api/new_rating'
  get 'api/search_reviews'
  
  get 'api/get_user_by_rating'
  get 'api/login_user'
  get 'api/register_new_user' 
  
  get 'api/login_with_social'

  root 'welcome#home'
  
  get '*path' => redirect('/')
end
