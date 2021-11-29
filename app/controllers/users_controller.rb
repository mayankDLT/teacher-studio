=begin 
  users_controller.rb
  Description: Controller file for managing the users of the application
  Created on: March 05, 2011
  Last modified on: March 18, 2013
  Copyright 2013 PIT Solutions Pvt. Ltd. All Rights Reserved.
=end

class UsersController < ApplicationController
  before_filter :get_indexdata , :only=>:index
  before_filter :check_perm_level, :only=>[:index,:new]
  before_filter :qs_getdata, :only=>[:edit, :new]
  filter_access_to :all
  
   def index               
      # need to add chinese text   
      if params[:search] != "" and params[:search] != nil and params[:search] != "Search User Id" and params[:search] != "Suche User Id" and params[:search] != "بحث معرف المستخدم"
          @users = User.search(params[:search],params[:create_id].to_i).order('created_at desc').paginate(:page => params[:page], :per_page => @pagelength)
      else
          @users = User.get_users(@current_user.role_id, @create_id.to_i, params[:examinee_temp]).order('created_at desc').paginate(:page => params[:page], :per_page => @pagelength)
      end       
  end  

  def new
    if @create_id=='2'
      @page_header=t('user.create_examiners')
      @value = Examiner
    elsif @create_id=='3'
      @page_header=t('user.create_qsetters')
      @value = Qsetter
    else
      @page_header=t('user.create_examinees')
      @value = Examinee
    end
    @user = User.new
    @roles = Role.find(:all)
  end
  
  def create
    @user = User.new(params[:user])    
    @pwd = params[:user][:password]
    @create_id = params[:user][:role_id]       
      if @create_id == Qsetter.to_s
        @subjects = params[:category].collect {|id| id.to_i} if params[:category]
        if @subjects
          @subjects.each do|subject|
            @subject = Categorysubject.find_by_id(subject)
            @user.categorysubjects << @subject       
          end
        end    
      end  
    if @user.save
        UserMailer.user_set_password(@user).deliver
        flash[:success] = t('flash_success.email_verification')
        redirect_to :action=>'index', :create_id => @create_id
    else
      flash[:notice] = t('flash_notice.user_not_created')
      redirect_to :back
    end
  end
  
  def generate_temporary_password
    @count = params[:temp_examinee][:count]
    @i = 1
    @password_array = []
    until 1 > @count
      @password_array = SecureRandom.hex(5)
      @i +=1
    end
    redirect_to :back
  end
  
  def tempexaminee
    @user = User.new
  end
  
  def show
    @user = @current_user
  end

  def edit
    @subjectUser = Subjectuser.where(['user_id = ?', params[:id].to_i])
    if current_user.id == params[:id].to_i or current_user.role_id == Admin and current_user.is_temp_examinee != 1
      @user = User.find_by_id_and_confirmed_and_is_approved(params[:id],true,1)
      unless @user == nil
        @value = @user.role_id
      else
        flash[:notice] = t('flash_notice.cant_edit_user_detail')
        redirect_to :back
      end    
    else
      flash[:notice] = t('flash_notice.cant_edit')
        if current_user.role_id == Examinee
          redirect_to :action=>"examinee_dashboard", :controller=>"welcome"
        elsif current_user.role_id == Examiner
          redirect_to :action=>"examiner_dashboard", :controller=>"welcome"
        elsif current_user.role_id == Qsetter
          redirect_to :action=>"qsetter_dashboard", :controller=>"welcome"
        end
    end
  end

  def deleteUsersubject
    userId = params[:user_id].to_i
    subjectId = params[:subject_id].to_i
    @subjectUser = Subjectuser.find_by_categorysubject_id_and_user_id(subjectId,userId)
    @subjectUser.destroy
    render :text => true
  end

 def update
    @user_id = params[:user_id]
    @user = User.find_by_id(params[:user_id].to_i)
    @create_id = params[:user][:role_id]
    
    if @create_id == Qsetter.to_s
    @subjects = params[:category].collect {|id| id.to_i} if params[:category]
    if @subjects
      @subjects.each do|subject|
        subjectUser = Subjectuser.find_by_user_id_and_categorysubject_id(params[:user_id].to_i,subject)
        if subjectUser == nil
        @subject = Categorysubject.find_by_id(subject)
        @user.categorysubjects << @subject
        @user.save
        end
      end
    end
    end
    @user.password = params[:password]
    if @user.update_attributes(params[:user])
         flash[:success] = t('flash_success.user_updated')
         redirect_to :back
    else
      flash[:notice] = t('flash_notice.user_update')
      #render :action => :edit
      redirect_to :back
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    categoryuser = Categoryuser.where(['user_id = ?',@user.id])
      if @user.role_id == 4
        if categoryuser.empty?
           @user.destroy
           flash[:success] = t('flash_success.examinee_del')
        else
           flash[:notice] = t('flash_notice.examinee_cant')
       end
      elsif @user.role_id == 2
           @user.destroy
           flash[:success] = t('flash_success.examiner_del')
      elsif @user.role_id == 3
           @user.destroy
           flash[:success] = t('flash_success.qsetter_del')
      end
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end
  
  def groupUser
    @examineeTypes = [[t('general.select'),""],
              [t('general.all'),"1"],
              [t('user.examinees'),"2"],
              [t('user.temp_examinee'),"3"]]
    pagenum = params[:pagenum].to_i
    @yrs = Array.new(10){|i| Date.current.year-i}
    
    @category = Category.new
    if params[:examineeType] == '2'
      @users = User.where(["role_id = ? and is_temp_examinee = ? and confirmed = ? and is_approved = ?", 4,0,true,1]).order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    elsif params[:examineeType] == '3'
      @users = User.where(["role_id = ? and is_temp_examinee = ? and confirmed = ? and is_approved = ?", 4,1,true,1]).order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    else
      @users = User.where(["role_id = ? and confirmed = ? and is_approved = ?", 4,true,1]).order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    end
      
    @category_types = CategoryType.where(["organization_id=?", @organization_id.to_i]).sort { |x,y| x.sort_order <=> y.sort_order }
    @c = Category.find(:all, :conditions=>["organization_id = ?", @organization_id])
  end

  def createGroup
    @getCategory = Category.find_by_id(params[:category][:id].to_i)   
    @examinees = params[:examinee]
      @examinees.each do|examinee|
        @categoryuser = Categoryuser.new
        @getExaminee = User.find_by_id(examinee.to_i)  
        @categoryuser.category_id = @getCategory.id
        @categoryuser.user_id = @getExaminee.id
        @categoryuser.currentyear = params[:academicYear]     
        @count = 1  if @categoryuser.save
      end
    if @count == 1 
      flash[:success] = t('flash_success.examinee_category')  
    else
      flash[:notice] = t('flash_notice.examinee_category_cant')
    end
    redirect_to :back
  end
  
  def activate_inactivate
    @examineeTypes = [[t('general.all'),"1"],
              [t('user.examiners'),"2"],
              [t('user.q_setters'),"3"],
              [t('user.examinees'),"4"]]
    @arr = [2,3,4]
    
    @pageCollect = params[:pageLength].to_i
    @pagelength = @pageCollect==0 ? 10 : @pageCollect 
    
    if params[:search] != "" and params[:search] != nil and params[:search] != t('user.search')
      @role = t('general.users')
      @users = User.search_user(params[:search]).order("created_at desc").paginate(:page => params[:page], :per_page => @pagelength)
    elsif params[:examineeType] == '2'
      @role = t('user.examiners')
      @users = User.conf_examiner_users.paginate(:page => params[:page], :per_page => @pagelength)
    elsif params[:examineeType] == '3'
      @role = t('user.q_setters')
     @users = User.conf_questionsetter_users.paginate(:page => params[:page], :per_page => @pagelength)
    elsif params[:examineeType] == '4'
      @role = t('user.examinees')
      @users = User.conf_examinee_users.order("created_at desc").paginate(:page => params[:page], :per_page => @pagelength)
    else
      @role = t('general.users')
      @users = User.all_users_wo_te.paginate(:page => params[:page], :per_page => @pagelength)
    end
  end
  
  def activate
   user = params[:user_id]
      @user = User.find_by_id(user.to_i)
      @user.update_attributes(:active => true)
      render :text => true
  end
 
 def inactivate
   user = params[:user_id]

      @user = User.find_by_id(user.to_i)
      @user.update_attributes(:active => false)
      render :text => true
 end
 
 protected 
 def get_indexdata      
    @pageCollect = params[:pageLength].to_i  
    @pagelength = @pageCollect==0 ? 10 : @pageCollect    
    @Selector_type = [[t('user.examinees'),"1"],[t('user.temp_examinee'),"2"]]    
      if params[:create_id].to_i == Examiner
        @name = t('user.examiners')
      elsif params[:create_id].to_i == Qsetter
        @name = t('user.q_setters')      
      else
        @name = params[:examinee_temp] == '2' ? t('user.temp_examinee') : t('user.examinees')
      end    
 end
 
 def check_perm_level
      @create_id = params[:create_id]
      @current_user = current_user  
      @allowed_UT=[2,3,4]   
      #Examinees and QSetter permissions are handled with authorization rules, below condition manages special cases
      if !@allowed_UT.include?(@create_id.to_i) || (@current_user.role_id == Examiner and @create_id.to_i==Examiner)
          flash[:notice] = t('flash_notice.not_permitted')
          redirect_to :action=>"examiner_dashboard", :controller=>:welcome
      end
      
 end
 
 def qs_getdata
      unless @organization_id == nil
        @category_subject = Categorysubject.find(:all, :joins=> "INNER JOIN categories ON categories.id = categorysubjects.category_id AND categories.organization_id = #{@organization_id}").paginate(:page => params[:page], :per_page => 10)
        @subjects = Subject.where(['organization_id = ?',@organization_id])
      end
 end
  

end

