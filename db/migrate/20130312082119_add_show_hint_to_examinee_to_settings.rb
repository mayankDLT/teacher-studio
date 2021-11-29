class AddShowHintToExamineeToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :show_hint_to_examinee, :boolean, :default => true
  end

  def self.down
    add_column :settings, :show_hint_to_examinee
  end
end
