=begin
  application_controller.rb
  Description: Controller file for managing the application.
  Created on: October 11, 2010
  Last modified on: March 18, 2013
  Copyright 2013 PIT Solutions Pvt. Ltd. All Rights Reserved.
=end

class ApplicationController < ActionController::Base
  
  before_filter :load_default_data
  
  helper :all  
  protect_from_forgery
  
  helper_method :current_user_session, :current_user    
  before_filter :set_locale, :set_time_zone
    
  def permission_denied  
    flash[:notice] = t('flash_notice.app_no_access')    
    redirect_to root_url  
  end
  
  def set_locale     
   if params[:locale] && I18n.available_locales.include?(params[:locale].to_sym)
      cookies['locale'] = { :value => params[:locale], :expires => 1.year.from_now }
      I18n.locale = params[:locale].to_sym
    elsif I18n.locale!=@app_setting.locale.to_sym && @app_setting.updated_at > 1.minutes.ago && I18n.available_locales.include?(@app_setting.locale.to_sym)
      cookies['locale'] = { :value => @app_setting.locale.to_sym, :expires => 1.year.from_now }
      I18n.locale = @app_setting.locale.to_sym        
    elsif cookies['locale'] && I18n.available_locales.include?(cookies['locale'].to_sym)
      if cookies['locale']!=@app_setting.locale && @app_setting.updated_at > 1.minutes.ago && I18n.available_locales.include?(@app_setting.locale.to_sym)
        cookies['locale'] = { :value => @app_setting.locale.to_sym, :expires => 1.year.from_now }
       end
      I18n.locale = cookies['locale'].to_sym
     end
  end
 
  private
  
    def set_time_zone
      Time.zone = @app_setting.time_zone
    end
  
    def current_user_session
      logger.debug "ApplicationController::current_user_session"
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end
 
    def current_user
      logger.debug "ApplicationController::current_user"
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end
 
    def require_user
      logger.debug "ApplicationController::require_user"
      unless current_user
        store_location
        flash[:notice] = t('flash_notice.login_access')   
        redirect_to new_user_session_url
        return false
      end
    end
 
    def require_no_user
      logger.debug "ApplicationController::require_no_user"
      if current_user
        store_location
        flash[:notice] = t('flash_notice.logout_access')
        redirect_to root_url
        return false
      end
    end
 
    def store_location
      session[:return_to] = request.request_uri
    end
 
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
    
    def load_default_data
      @app_setting = Setting.find(:first)
      @organization_id = Setting.find(:first).organization_id
      @category_types = CategoryType.find_all_by_organization_id(@organization_id.to_i) if @organization_id
    end
    
      protected
        def set_paging_params
          @per_page = params[:per_page] ? params[:per_page].to_i : 10
          @page_num = params[:page] ? params[:page].to_i : 1
          @to_skip = ( @page_num - 1 ) * (@per_page)
          @max_index = @per_page * @page_num
        end
end
