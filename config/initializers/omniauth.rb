Rails.application.config.middleware.use OmniAuth::Builder do
    provider :facebook, '415029245237304', 'b41295626d7518f112d7e30df2304c98'
    # provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
end