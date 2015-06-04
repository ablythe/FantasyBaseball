class CreateYahooApiTokens < ActiveRecord::Migration
  def change
    create_table :yahoo_api_tokens do |t|
      t.string :oauth_token
      t.string :oauth_token_secret
      t.string :oauth_session_handle
      t.datetime :token_expires_in
      t.datetime :authorization_expires_in
      t.string :yahoo_guid

      t.timestamps null: false
    end
  end
end
