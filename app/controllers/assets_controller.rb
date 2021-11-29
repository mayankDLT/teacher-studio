=begin
  assets_controller.rb
  Description: Controller file for managing files in Document Sharing feature.
  Created on: June 12, 2012
  Last modified on: October 29, 2012
  Copyright 2013 PIT Solutions Pvt. Ltd. All Rights Reserved.
=end

class AssetsController < ApplicationController
  filter_access_to :all
  
  layout "documentSharing"
  def index  
    if current_user  
      @assets = current_user.assets.order("uploaded_file_file_name desc")        
    end  
  
  end  
  
  def show  
    @asset = current_user.assets.find(params[:id])  
  end  
  
  def new  

    @asset = current_user.assets.build      
    if params[:folder_id] #if we want to upload a file inside another folder  
     @current_folder = current_user.folders.find(params[:folder_id])  
     @asset.folder_id = @current_folder.id  
    end      
  end   
  
def create  
  
  @asset = current_user.assets.build(params[:asset])  
  if @asset.save  
   flash[:success] = t('document.file_upload_success')
  
   if @asset.folder #checking if we have a parent folder for this file  
     redirect_to browse_path(@asset.folder)  #then we redirect to the parent folder  
   else  
     redirect_to :action=>:index  
   end        
  else  
   render :action => 'new'  
  end  
end   
  
  def edit  
    @asset = current_user.assets.find(params[:id])  
  end  
  
  def update  
    @asset = current_user.assets.find(params[:id]) 
    @parent_folder = @asset.folder 
 if @asset.update_attributes(params[:asset])
      flash[:success] = "Updated Successfully!" 
      redirect_to browse_path(@parent_folder) 
    else
      flash[:error] = "Process failed!!!"
      render :edit
    end 
  end  
  
    def destroy  
      @asset = current_user.assets.find(params[:id])  
      @parent_folder = @asset.folder #grabbing the parent folder before deleting the record  
      @asset.destroy  
      flash[:notice] = "Successfully deleted the file."  
      
      #redirect to a relevant path depending on the parent folder  
      if @parent_folder  
       redirect_to browse_path(@parent_folder)  
      else  
       redirect_to root_url  
      end  
    end  
  
def get  
 #first find the asset within own assets  
 asset = current_user.assets.find_by_id(params[:id])  
  
 #if not found in own assets, check if the current_user has share access to the parent folder of the File  
 asset ||= Asset.find(params[:id]) #if current_user.has_share_access?(Asset.find_by_id(params[:id]).folder)  
  
 if asset  
   #Parse the URL for special characters first before downloading  
   send_file asset.uploaded_file.path, :type => asset.uploaded_file_content_type   
   #redirect_to asset.uploaded_file.url  
 else  
   flash[:error] = "Don't be cheeky! Mind your own assets!"  
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
      @shared_folder.shared_email = email_address.strip    
      #getting the shared user id right the owner the email has already signed up with ShareBox  
      #if not, the field "shared_user_id" will be left nil for now.  
      shared_user = User.find_by_email(email_address.strip) 
      @shared_folder.shared_user_id = shared_user.id if shared_user  
    
      @shared_folder.message = params[:message]  
      unless email_address == " "
      @shared_folder.save  
      end
      #now we need to send email to the Shared User  
      #UserMailer.invitation_to_share(@shared_folder).deliver  
    end  
  
    #since this action is mainly for ajax (javascript request), we'll respond with js file back (refer to share.js.erb)  
    #respond_to do |format|  
    #  format.js {  
    #  }  
    #end 
    unless email_addresses.empty?
      render :json => {:text=>true}
    else
      render :json => {:text=>false}
    end
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
    render :json => {:duplicate=>true}
  end 
  
  def unshare
    #f = File.open("unshare.txt", "a")
      @get_ids = params[:shared_ids]
      @folder_id = params[:folder_id]
      @folder_name = Folder.select(:name).where(:id => @folder_id)
      unless @get_ids.blank?
        @get_ids.each do |get_id|
          SharedFolder.where(:shared_user_id => get_id, :folder_id => @folder_id).destroy_all
        end
      end
      flash[:success] = t('document.sp_folder') + " '#{@folder_name.first.name}' " + t('document.success_unshare')
      redirect_to :back
    #f.close
  end
  
  def lock
    @asset = Asset.find_by_id(params[:asset_id])
    unless @asset == nil
      @asset.lock = 1
      @asset.save
      render :text => true
    else
      render :text => false
    end
  end
  
  def unlock
    @asset = Asset.find_by_id(params[:asset_id])
    unless @asset == nil
      @asset.lock = 0
      @asset.save
      render :text => true
    else
      render :text => false
    end
  end

end

