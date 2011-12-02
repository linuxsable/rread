Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '137065989735336', '713781007928349d79934d6121ff2f0f'
end