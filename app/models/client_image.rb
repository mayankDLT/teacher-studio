class ClientImage < ActiveRecord::Base
    has_attached_file :image,
     :styles => {  :thumb => '235x60*' }
  #validates_format_of  :image, :with => %r(gif|jpg|png)
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/jpg']
end
