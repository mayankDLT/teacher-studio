class User < ActiveRecord::Base

       acts_as_authentic do |c|
       c.require_password_confirmation = false
       c.validate_password_field = false
       end
  #scope :made_between, lambda{|from, to| where('created_date >= :from and created_date <= :to', :from => from, :to => to) }
  scope :conf_examiner_users, where(:role_id => 2, :confirmed => true).order('created_at desc')
  scope :conf_questionsetter_users, where(:role_id => 3, :confirmed => true).order('created_at desc')
  scope :conf_examinee_users, where(:role_id => 4, :is_temp_examinee=>0, :confirmed => true).order('created_at desc')
  scope :examiner_users, where(:role_id => 2).order('created_at desc')
  scope :questionsetter_users, where(:role_id => 3).order('created_at desc')
  scope :allexaminee_users, where(:role_id => 4).order('created_at desc')
  scope :examinee_users, where(:role_id => 4, :is_temp_examinee=>0).order('created_at desc')
  scope :tempexaminee_users, where(:role_id => 4, :is_temp_examinee=>1).order('created_at desc')
  scope :acemn_users, where(:role_id => 4, :is_approved=>1, :is_temp_examinee=>0, :confirmed=>true).order("created_at desc") 
  scope :actemn_users, where(:role_id => 4, :is_approved=>1, :is_temp_examinee=>1, :confirmed=>true).order("created_at desc") 
  scope :acaemn_users, where(:role_id => 4, :is_approved=>1, :confirmed=>true).order("created_at desc") 
  scope :approvedexaminee_users, where(:role_id => 4, :is_approved=>1) 
  scope :all_users_wo_te, where(["role_id in (?) and is_temp_examinee = ? and confirmed = ?",[2,3,4],0, true]).order('created_at desc')
  

 #-------------------document sharing---------------------------------
  after_create :check_and_assign_shared_ids_to_shared_folders
  
  has_many :shared_folders_by_others, :through => :being_shared_folders, :source => :folder
  
  has_many :shared_folders, :dependent => :destroy
  has_many :being_shared_folders, :class_name => "SharedFolder", :foreign_key => "shared_user_id", :dependent => :destroy  

  has_many :folders 
  has_many :assets 
 
 #--------------------------------------------------------------------

  has_many :articles, :dependent => :destroy  

  has_many :shared_question
  has_many :questions, :through => :shared_question

  has_one :categoryuser
  has_one :category, :through => :categoryuser

  belongs_to :role 
  
  has_and_belongs_to_many :subjects
  has_many :evaluations
  has_many :exam_results
  has_many :questions
  has_one :feedback
  has_many :reports
  
  
  has_many :categories
  has_many :categories, :through => :categoryuser
  
  has_many :subjectusers, :class_name=>'Subjectuser'
  has_many :subjects, :through => :subjectusers
  
  has_many :categorysubjects, :through => :subjectusers

  has_many :evaluate_exams
  has_many :exams, :through=> :evaluate_exams

  def self.find_by_login_or_email(login)
   find_by_login(login) || find_by_email(login)
  end

  def role_symbols  
   @role = []
   @role << role.name.underscore.to_sym
  end

  def self.get_users r_id, nr_id, et_id
    
        if r_id == 1 and nr_id == 2
          User.examiner_users
        elsif r_id == 1  or r_id == 2  and nr_id == 3
          User.questionsetter_users
        elsif et_id == '2'
           User.tempexaminee_users         
        elsif et_id == '1' 
          User.examinee_users
        elsif et_id == '0'
          User.allexaminee_users
        elsif r_id == 1  or r_id == 2 and nr_id == 4
          User.allexaminee_users
        end 
    
  end

  def self.search(search,role)
    if search
      where(['(login LIKE ? OR name LIKE ? OR email LIKE ?) AND role_id = ?', "%#{search}%", "%#{search}%", "%#{search}%",role])
    end
  end

  def self.search_user(search) 
  if search
    where("(login LIKE ? OR name LIKE ? OR email LIKE ?) AND confirmed = ?", "%#{search}%", "%#{search}%", "%#{search}%", true)
  end
  end

  #this is to make sure the new user ,of which the email addresses already used to share folders by others, to have access to those folders  
  def check_and_assign_shared_ids_to_shared_folders      
      #First checking if the new user's email exists in any of ShareFolder records  
      shared_folders_with_same_email = SharedFolder.find_all_by_shared_email(self.email)  
    
      if shared_folders_with_same_email        
        #loop and update the shared user id with this new user id   
        shared_folders_with_same_email.each do |shared_folder|  
          shared_folder.shared_user_id = self.id  
          shared_folder.save  
        end  
      end      
  end
  
  def has_share_access?(folder)  
    #has share access if the folder is one of one of his own  
    return true if self.folders.include?(folder)  
      
    #has share access if the folder is one of the shared_folders_by_others  
    return true if self.shared_folders_by_others.include?(folder)  
  
    #for checking sub folders under one of the being_shared_folders  
    return_value = false  
    folder.ancestors.each do |ancestor_folder|  
      return_value = self.shared_folders_by_others.include?(ancestor_folder)  
      if return_value #if it's true  
        return true  
      end  
    end  
  
    return false  
   end 


end
