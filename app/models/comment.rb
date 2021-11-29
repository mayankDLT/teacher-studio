class Comment < ActiveRecord::Base
  belongs_to :article
  validates_presence_of :name, :comment
  validates :email,   
            :presence => true,     
            :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }  
end
