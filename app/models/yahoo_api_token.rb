class YahooApiToken < ActiveRecord::Base
  require 'open-uri'

  ID = ENV["consumer_key"]
  SECRET =ENV["consumer_secret"]

  def self.authorize
    nonce = SecureRandom.hex()
    ts=Time.now.to_i
    q = URI.encode_www_form(
     "oauth_nonce" => nonce,
     "oauth_timestamp" => ts,
     "oauth_consumer_key" => ID,
     "oauth_signature" => "#{SECRET}&",
     "oauth_signature_method" => "plaintext",
     "oauth_version" => "1.0",
     "xoauth_lang_pref" => "en-us",
     "oauth_callback" => "oob"
     )  
    
    response =HTTParty.get("https://api.login.yahoo.com/oauth/v2/get_request_token?#{q}")
    p=CGI.parse(response)    
    

  end

  def self.get_access_token args, code  
    yahoo_oauth_token = args["oauth_token"].first
    oauth_token_secret = args["oauth_token_secret"].first
    

  nonce = SecureRandom.hex()
  ts=Time.now.to_i
  q = URI.encode_www_form(
    "oauth_nonce" => nonce,
    "oauth_timestamp" => ts,
    "oauth_consumer_key" => ID,
    "oauth_signature" => "#{SECRET}&#{oauth_token_secret}",
    "oauth_signature_method" => "plaintext",
    "oauth_version" => "1.0",
    "xoauth_lang_pref" => "en-us",
    "oauth_token" => yahoo_oauth_token,
    "oauth_verifier" => code
    )
  response =HTTParty.get("https://api.login.yahoo.com/oauth/v2/get_token?#{q}")
  parsed =CGI.parse(response)
  YahooApiToken.create!(
    oauth_token:  parsed["oauth_token"].first,
    oauth_token_secret: parsed["oauth_token_secret"].first,
    oauth_session_handle: parsed["oauth_session_handle"].first,
    token_expires_in: Time.now + parsed["oauth_expires_in"].first.to_i,
    authorization_expires_in:    Time.now + parsed["oauth_authorization_expires_in"].first.to_i,
    yahoo_guid: parsed["xoauth_yahoo_guid"].first
    )
  
end

def self.refresh_token 
  expired =YahooApiToken.first
  nonce = SecureRandom.hex()
  ts=Time.now.to_i
  q = URI.encode_www_form(
    "oauth_nonce" => nonce,
    "oauth_timestamp" => ts,
    "oauth_consumer_key" => ID,
    "oauth_signature" => "#{SECRET}&#{expired.oauth_token_secret}",
    "oauth_signature_method" => "plaintext",
    "oauth_version" => "1.0",
    "oauth_token" => expired.oauth_token,
    "oauth_session_handle" => expired.oauth_session_handle
    )
  response =HTTParty.get("https://api.login.yahoo.com/oauth/v2/get_token?#{q}")
  parsed =CGI.parse(response)
  YahooApiToken.create!(
    oauth_token:  parsed["oauth_token"].first,
    oauth_token_secret: parsed["oauth_token_secret"].first,
    oauth_session_handle: parsed["oauth_session_handle"].first,
    token_expires_in: Time.now + parsed["oauth_expires_in"].first.to_i,
    authorization_expires_in:    Time.now + parsed["oauth_authorization_expires_in"].first.to_i,
    yahoo_guid: parsed["xoauth_yahoo_guid"].first
    )

end

def get_player_stats
  q= URI.encode_www_form(
  "oauth_consumer_key" => ID,
  "oauth_token" => "#{self.oauth_token}",
  "oauth_signature" => "#{SECRET}&#{self.oauth_token_secret}",
  "oauth_signature_method" => "plaintext",
  "oauth_version" => "1.0",
  "oauth_timestamp" => Time.now.to_i,
  "oauth_nonce" => SecureRandom.hex()
)


  response= HTTParty.get("https://query.yahooapis.com/v1/yql?q=select%20*%20from%20fantasysports.teams%20where%20team_key%3D'346.l.21725.t.8'&#{q}",
)
  
  end

  
end