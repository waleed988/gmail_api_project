module ApplicationHelper
  def create_client
    secrets = Google::Auth::ClientId.from_file(
      Rails.root.join('config/client_secret.json')
    )
  
    client = Google::Auth::UserRefreshCredentials.new(
      client_id: secrets.id,
      client_secret: secrets.secret,
      redirect_uri: 'http://localhost:3000/google/oauth2/callback',
      access_token: GmailToken.last&.expired? ? refresh_token : GmailToken.last&.token,
      code: GmailToken.last&.code,
      scope: 'https://www.googleapis.com/auth/gmail.readonly openid email profile'
    )
  end

  def refresh_token
    if GmailToken.last.expired?
      new_token = create_client.refresh!
      GmailToken.last.update(token: new_token['access_token'], expires_at: Time.now + new_token['expires_in'].to_i.seconds)
    end
  end

  def list_user_messages(gmail, client)
    gmail.authorization = client
    gmail.list_user_messages('me').messages || {}
  end
    
end
