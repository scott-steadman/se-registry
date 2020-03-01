class CreateUsers < ActiveRecord::Migration[6.0]

  def change
    create_table :users do |t|
      t.string    :login,             :null => false
      t.index     :login
      t.string    :role,              :null => false, :default => 'user'
      t.string    :notes
      t.timestamps

      # AuthLogic::ActsAsAuthentic::Email
      t.string    :email
      t.index     :email,             :unique => true

      # AuthLogic::ActsAsAuthentic::Password
      t.string    :crypted_password,  :null => false
      t.string    :password_salt,     :null => false

      # AuthLogic::ActsAsAuthentic::PersistenceToken
      t.string    :persistence_token
      t.index     :persistence_token, :unique => true

      # See "Magic Columns" in Authlogic::Session::Base
      t.timestamp :current_login_at
      t.timestamp :last_login_at
    end
  end

end
