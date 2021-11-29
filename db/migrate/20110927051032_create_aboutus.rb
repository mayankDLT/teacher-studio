class CreateAboutus < ActiveRecord::Migration
  def self.up
    create_table :aboutus, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci' do |t|
      t.text :description
      t.integer :locale_id, :default=>0
      t.timestamps
    end
  end

  def self.down
    drop_table :aboutus
  end
end

