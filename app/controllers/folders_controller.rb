=begin
  folders_controller.rb
  Description: Controller file for managing the folder structure in Document Sharing feature.
  Created on: June 12, 2012
  Last modified on: October 29, 2012
  Copyright 2013 PIT Solutions Pvt. Ltd. All Rights Reserved.
=end

class FoldersController < ApplicationController
  autocomplete :folder, :name
 filter_access_to :all 
layout "documentSharing"
  
def getName  
  if params[:term]

    @people = User.find(:all,:conditions => ['name LIKE ?', "#{params[:term]}%"])
  else
    @people = User.all
  end

  respond_to do |format|  
    format.html # index.html.erb  
# Here is where you can specify how to handle the request for "/people.json"
    format.json { render :json => @people.to_json }
    #format.json {render :json => {:userNames=>@people} }
    end
end

 def index  
    if current_user  
      #show folders shared by others  
      @being_shared_folders = current_user.shared_folders_by_others  
    
      #show only root folders  
      @folders = current_user.folders.roots  
      #show only root files  
      @assets = current_user.assets.where("folder_id is NULL").order("uploaded_file_file_name desc")     
      
  end
  

 end   
  
 def show  
    @folder = current_user.folders.find(params[:id])  
 end  
  
def new  
   @folder = current_user.folders.new       
   #if there is "folder_id" param, we know that we are under a folder, thus, we will essentially create a subfolder  
   if params[:folder_id] #if we want to create a folder inside another folder  
       
     #we still need to set the @current_folder to make the buttons working fine  
     @current_folder = current_user.folders.find(params[:folder_id])  
       
     #then we make sure the folder we are creating has a parent folder which is the @current_folder  
     @folder.parent_id = @current_folder.id  
   end  
end 
  
def create  
   @folder = current_user.folders.build(params[:folder])  

   if @folder.save  
    flash[:success] = "Successfully created folder."  
      
    if @folder.parent #checking if we have a parent folder on this one  
      redirect_to browse_path(@folder.parent)  #then we redirect to the parent folder  
    else  
      redirect_to :action=>:index #if not, redirect back to home page  
    end  
   else  
    render :action => 'new'  
   end  
end  
  
def edit  
    @folder = current_user.folders.find(params[:folder_id])  
    @current_folder = @folder.parent    #this is just for breadcrumbs  
end  
  
 def update  
    @folder = current_user.folders.find(params[:id])  
    
    if @folder.update_attributes(params[:folder])
      flash[:success] = "Updated Successfully!" 
        if @folder.parent #checking if we have a parent folder on this one  
          redirect_to browse_path(@folder.parent)  #then we redirect to the parent folder  
        else  
          redirect_to :action=>:index #if not, redirect back to home page  
        end  
    else
      flash[:error] = "Process failed!!!"
      render :edit
    end 

 end  
  
    def destroy  
       @folder = current_user.folders.find(params[:id])  
       @parent_folder = @folder.parent #grabbing the parent folder  
      
       #this will destroy the folder along with all the contents inside  
       #sub folders will also be deleted too as well as all files inside  
       @folder.destroy  
       flash[:notice] = "Successfully deleted the folder and all the contents inside."  
      
       #redirect to a relevant path depending on the parent folder  
       if @parent_folder  
        redirect_to browse_path(@parent_folder)  
       else  
        redirect_to :back        
       end  
    end  
 
def browse  
  #first find the current folder within own folders  
  @current_folder = current_user.folders.find_by_id(params[:folder_id])    
  @is_this_folder_being_shared = false if @current_folder #just an instance variable to help hiding buttons on View  
    
  #if not found in own folders, find it in being_shared_folders  
  if @current_folder.nil?  
    folder = Folder.find_by_id(params[:folder_id])  
      
    @current_folder ||= folder if current_user.has_share_access?(folder)  
    @is_this_folder_being_shared = true if @current_folder #just an instance variable to help hiding buttons on View  
      
  end  
    
  if @current_folder  
    #if under a sub folder, we shouldn't see shared folders  
    @being_shared_folders = []  
      
    #show folders under this current folder  
    @folders = @current_folder.children  
      
    #show only files under this current folder  
    @assets = @current_folder.assets.order("uploaded_file_file_name desc")  
      
    render :action => "index"  
  else  
    flash[:error] = "Access Denied - You have no permission to access this folder."  
    redirect_to root_url  
  end  
end
 
  def share      
    #first, we need to separate the emails with the comma  
    email_addresses = params[:email_addresses].split(",")  
      
    email_addresses.each do |email_address|  
      #save the details in the ShareFolder table  
      @shared_folder = current_user.shared_folders.new  
      @shared_folder.folder_id = params[:folder_id]  
      @shared_folder.shared_email = email_address  
    
      #getting the shared user id right the owner the email has already signed up with ShareBox  
      #if not, the field "shared_user_id" will be left nil for now. 

      shared_user = User.find_by_email(email_address)  
      @shared_folder.shared_user_id = shared_user.id if shared_user  
    
      @shared_folder.message = params[:message]  
      @shared_folder.save  
    
      #now we need to send email to the Shared User  
      #UserMailer.invitation_to_share(@shared_folder).deliver  
    end  
  
    #since this action is mainly for ajax (javascript request), we'll respond with js file back (refer to share.js.erb)  
    respond_to do |format|  
      format.js {  
      }  
    end  
  end 
  
  def unshareFolder
   @shared_to_users = SharedFolder.where("folder_id = ? AND shared_user_id IS NOT NULL", params[:unshare])
   @shared_folder = Folder.find_by_id(params[:unshare])
   if @shared_to_users.nil?
      @shared_user = User.find_by_id(@shared_to_users.first.user_id)
   end 
   render :layout => false
 end

end

