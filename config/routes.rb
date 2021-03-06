Rails.application.routes.draw do
  
  get 'welcome/home'

  match 'auth/:provider/callback', to: 'users#login_from_social', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'users#logout', as: 'signout', via: [:get, :post]
  
  post '/rate' => 'rater#create', :as => 'rate'
  resources :users
  resources :ratings
  resources :categories
  
  resources :reviews do
    resources :ratings
  end

  resources :users do
    resources :ratings
    resources :messages
  end
  
  get 'report_user/:id', :to => "users#report_user", :as => 'report_user'
  get 'reset_user/:id', :to => "users#reset_user", :as => 'reset_user'
  get 'show_reported_user', :to => "users#show_reported_user"
  get 'report_review', :to => "reviews#report_review", :as => 'report_review'
  get 'reset_review/:id', :to => "reviews#reset_review", :as => 'reset_review'
  get 'show_reported_review', :to => "reviews#show_reported_review"
  get 'report_rating/:id', :to => "ratings#report_rating", :as => 'report_rating'
  get 'reset_rating/:id', :to => "ratings#reset_rating", :as => 'reset_rating'
  get 'show_reported_rating', :to => "ratings#show_reported_rating"
  
  
  get '/logout' => 'users#logout'
  get "login", :to => "users#login"
  get '/register', :to => "users#new"
  get "login_attempt", :to => "users#login_attempt"
  get 'forgot_password', :to => "application#forgot_password"
  get 'cookies_policy', :to => "application#cookies_policy"
  get 'privacy_policy', :to => "application#privacy_policy"
  get 'user_agreement', :to => "welcome#eula"
  get 'eula', :to => "welcome#eula"  
  post "login_attempt", :to => "users#login_attempt"
  post 'reviews/search_by_place'
  
  get 'update_user_location', :to => 'users#update_user_location'
  get 'update_user_radius', :to => 'users#update_user_radius'
  
  get 'messages/delete/:id', :to => 'messages#destroy'
  get 'messages/set_read/:id', :to => 'messages#set_read'
  get 'messages/new_message', :to => 'messages#new_message'

  get 'messages/post_message_to_user', :to => 'messages#post_message_to_user'

  get 'api/show_reviews'
  post 'api/new_review'
  get 'api/show_ratings'
  get 'api/new_rating'
  get 'api/search_reviews'
  get 'api/get_user_by_rating'
  get 'api/login_user'
  get 'api/register_new_user' 
  get 'api/login_with_social'
  get 'api/report_review'
  get 'api/report_user'
  get 'api/get_messages'
  get 'api/set_message_read'
  get 'api/set_message_unread'
  get 'api/delete_message'
  get 'api/delete_all_messages'
  get 'api/get_num_of_messages'
  get 'api/get_category_image'
  get 'api/get_categories'
  get 'api/new_message_to_user'

  get 'eula', :to => 'welcome#eula'
  get 'start', :to => 'application#start'
  root 'welcome#home'
  
  get '*path' => redirect('/')
end
