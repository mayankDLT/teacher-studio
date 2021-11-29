class Folder < ActiveRecord::Base
  acts_as_tree 
  belongs_to :user 
  has_many :assets, :dependent => :destroy
  
  has_many :shared_folders, :dependent => :destroy  
  
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [:parent_id], :message=>" already exists!"
  
  def shared?  
    !self.shared_assets.empty?  
  end
  
end
