Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Rails.application.config.fb_app_id, Rails.application.config.fb_app_secret
end