class CreateGmailTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :gmail_tokens do |t|
      t.string :token
      t.string :expires_at
      t.string :code

      t.timestamps
    end
  end
end
