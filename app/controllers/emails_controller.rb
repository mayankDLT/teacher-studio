=begin
  emails_controller.rb
  Description: Controller file for managing the Email contents.
  Created on: January 11, 2011
  Last modified on: October 29, 2012
  Copyright 2013 PIT Solutions Pvt. Ltd. All Rights Reserved.
=end

class EmailsController < ApplicationController
  filter_access_to :all
  def index
    @email_templates = Email::Email_Template_List
  end
  
  def edit
    @email_template = Email.find_by_section_id(params[:id])
    @help_content = @email_template.help_content
    unless @help_content == nil
    @collection = @help_content.split(",").collect{ |s| s }
    end
  end
  
  def update
    @section_id = params[:email][:section_id]
    @template_update = Email.find_by_section_id(@section_id)
    if @template_update.update_attributes(params[:email])
      flash[:success] = t('flash_success.email_temp_updated')
      redirect_to :action=>"index", :controller=>"emails"
    else
      render :action => :edit
    end
  end
  
end
