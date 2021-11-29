class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string    :name,                :null => true
      t.string    :login,               :null => false
      t.string    :email,               :null => false
      t.string    :crypted_password,    :null => true
      t.string    :password_salt,       :null => true
      t.string    :persistence_token,   :null => false
      #t.string    :single_access_token, :null => false                # optional, see Authlogic::Session::Params
      t.string    :perishable_token,    :null => false                # optional, see Authlogic::Session::Perishability
 
      # magic fields (all optional, see Authlogic::Session::MagicColumns)
      
      t.integer   :login_count,         :null => false, :default => 0
      t.string    :language, :default=>'en'
      t.integer   :failed_login_count,  :null => false, :default => 0
      t.datetime  :last_request_at
      t.datetime  :current_login_at
      t.datetime  :last_login_at
      t.string    :current_login_ip
      t.string    :last_login_ip
      t.integer   :role_id
      t.boolean   :confirmed, :default => false
      t.integer   :is_approved, :default => 0
      t.integer   :is_temp_examinee, :null => false, :default => 0
      t.boolean   :active, :default => true
      t.timestamps
    end
 
    add_index :users, ["login"], :name => "index_users_on_login", :unique => true
    add_index :users, ["email"], :name => "index_users_on_email", :unique => true
    add_index :users, ["persistence_token"], :name => "index_users_on_persistence_token", :unique => true
 
  end
 
  def self.down
    drop_table :users
  end
end
