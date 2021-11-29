class AddContentArAndContentZhToEmails < ActiveRecord::Migration
  def self.up
    add_column :emails, :content_ar, :text
    add_column :emails, :content_zh, :text
  end

  def self.down
    add_column :emails, :content_ar
    add_column :emails, :content_zh
  end
end
