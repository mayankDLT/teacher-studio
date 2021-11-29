class AddTimeZoneToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :time_zone, :string, :default => 'New Delhi'
  end

  def self.down
    add_column :settings, :time_zone, :string
  end
end
