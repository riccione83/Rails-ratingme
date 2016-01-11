OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '907940565955155', '9a6d7a3d34bc9cc4e02790e46366da10',
  :scope => 'email,public_profile', :display => 'popup'
  
  provider :twitter, "eToAW58eo0KFxvS61noCyRB89", "oGr0v4fcqQgCQ1SO1WWutRGP3r8NmBYibyRUoDG1iHfMMUPhWI"
  {
    :use_authorize => 'true'
  }
  
end