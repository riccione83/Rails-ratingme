OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FB_KEY'], ENV['FB_SECRET'], :scope => 'email, public_profile', :display => 'popup'
  
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  {
    :use_authorize => 'true'
  }
  
end