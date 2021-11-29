=begin
  settings_controller.rb
  Description: Controller file for managing configuration settings of the application.
  Created on: October 11, 2010
  Last modified on: March 18, 2013
  Copyright 2013 PIT Solutions Pvt. Ltd. All Rights Reserved.
=end

class SettingsController < ApplicationController
  filter_access_to :all
  
  def index    
    if params[:locale]
      @setting = Setting.find(:first)
      @setting.locale = params[:locale]
      @setting.save
    end   
    @Selector_type = [["%m/%d/%Y","%m/%d/%Y"],
              ["%m/%d/%Y %I:%M%p","%m/%d/%Y %I:%M%p"],
              ["%m/%d/%Y %H:%M","%m/%d/%Y %H:%M"]]
              
    @organization_types = [[t('org.school'),"1"],
              [t('org.univ_college'),"2"],
              [t('org.organization'),"3"],
              [t('org.training_inst'),"4"]]
              
    @approve_examinee = [[t('general.approve'),"1"],
              [t('general.disapprove'),"0"]]
    
    @Locale_type = [[t('locale.english'),"en"], [t('locale.german'),"de"], [t('locale.arabic'),"ar"], [t('locale.chinese'),"zh"]]
    @setting = Setting.find(:first)
    unless @setting.organization_id == nil
    @organizationName = Organization.find_by_id(@setting.organization_id).id
    @dateFormat = @setting.datetime_format
    @locale = @setting.locale
    @approveExaminee = @setting.examineeApprove
    end
  end
  
  def update
    @setting = Setting.find(:first)
    @setting.allow_examinee_registration = params[:allow_examinee_reg]
    @setting.show_hint_to_examinee = params[:show_hints_to_examinee]
    @setting.confirm_exam = params[:confirm_exam]
    @setting.datetime_format = params[:dateformat]
    @setting.locale = params[:locale]
    @setting.organization_id = params[:orgnization_type]
    @setting.examineeApprove = params[:approve_examinee]
    @setting.url = params[:url]
    @setting.time_zone = params[:time_zone]
    if @setting.save  
    flash[:success] = t('flash_success.settings_updated')
    redirect_to :action=>"index"
    end
  end

 
end
