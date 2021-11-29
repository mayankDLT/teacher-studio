class CreateSharedFolders < ActiveRecord::Migration
  def self.up
    create_table :shared_folders do |t|
      t.integer :user_id
      t.string :shared_email
      t.integer :shared_user_id
      t.integer :folder_id
      t.string :message

      t.timestamps
    end
    add_index :shared_folders, :user_id  
    add_index :shared_folders, :shared_user_id  
    add_index :shared_folders, :folder_id 
    add_index :shared_folders, [ :user_id, :shared_user_id, :folder_id ], :unique => true, :name => 'by_user_id_and_shared_user_id_and_folder_id'
  end

  def self.down
    drop_table :shared_folders
  end
end
