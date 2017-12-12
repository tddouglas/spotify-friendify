keys = Rails.application.secrets

# Make sure to get right scope that app can get access to required data (https://developer.spotify.com/web-api/using-scopes/)
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, keys.spotify_client_id, keys.spotify_client_secret, scope: 'playlist-read-private user-read-private user-read-email user-top-read'
end