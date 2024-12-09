Rails.application.config.middleware.use OmniAuth::Builder do
    provider :twitter,
        Rails.application.credentials.dig(:TWITTER_CLIENT_ID),
        Rails.application.credentials.dig(:TWITTER_CLIENT_SECRET),
        {
        scope: 'read:user',
        redirect_uri: 'http://localhost:3000/auth/twitter/callback'
        }
    provider :github, 
    
        Rails.application.credentials.dig(:GITHUB_CLIENT_ID), 
        Rails.application.credentials.dig(:GITHUB_CLIENT_SECRET), 
        scope: "user:email" # Adjust scope as needed
end

OmniAuth.config.allowed_request_methods = [:post, :get]
OmniAuth::AuthenticityTokenProtection.default_options(key: "csrf.token", authenticity_param: "_csrf")