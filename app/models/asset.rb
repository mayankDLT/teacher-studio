class Asset < ActiveRecord::Base
  
 #------------- paperclip -------------------

attr_accessible :user_id, :uploaded_file  
belongs_to :user  
  
#set up "uploaded_file" field as attached_file (using Paperclip)  
has_attached_file :uploaded_file  
    #has_attached_file :uploaded_file,  
    #               :url => "/assets/get/:id",  
    #               :path => ":Rails_root/assets/:id/:basename.:extension"  

validates_attachment_size :uploaded_file, :less_than => 10.megabytes    
validates_attachment_presence :uploaded_file
validates_uniqueness_of :uploaded_file_file_name, :scope => [:folder_id], :message=>" already exists!"
validates_length_of :uploaded_file_file_name, :maximum => 45
#-------------paperclip end ---------------- 

attr_accessible :user_id, :uploaded_file, :folder_id  
belongs_to :folder

def file_name  
    uploaded_file_file_name  
end

def file_size  
    uploaded_file_file_size  
end

def locked?
   if self.lock?
     return true
   else
     return false
   end
end

end

