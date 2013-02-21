Rails.application.config.middleware.use OmniAuth::Builder do
  provider :csb, CSB_CONSUMER_KEY, CSB_CONSUMER_SECRET
end
