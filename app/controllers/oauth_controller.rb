class OauthController < ApplicationController
  include ApplicationHelper

  def index
    client = create_client()
    session[:google_oauth_client] = client.to_json
    redirect_to client.authorization_uri.to_s, google_client: client
  end

  def callback
    client = Google::Auth::UserRefreshCredentials.from_hash(JSON.parse(session[:google_oauth_client]))
    client.code = params[:code]
    access_token_hash = client.fetch_access_token!
    GmailToken.upsert( {token: access_token_hash['access_token'], code: params[:code], expires_at: Time.now + access_token_hash['expires_in'].to_i.seconds, created_at: Time.now, updated_at: Time.now})
    
    redirect_to root_url
  end
end
