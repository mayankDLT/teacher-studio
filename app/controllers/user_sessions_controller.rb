=begin 
  user_sessions_controller.rb
  Description: Controller file for managing the user sessions
  Created on: March 05, 2011
  Last modified on: March 18, 2013
  Copyright 2013 PIT Solutions Pvt. Ltd. All Rights Reserved.
=end

class UserSessionsController < ApplicationController
  layout 'loginLayout'
  
  def new
    @user_session = UserSession.new
    @setting = Setting.find(:first)
    @allow_dr = @setting.allow_examinee_registration
  end
 
  def create
    @user_session = UserSession.new(params[:user_session])
    @login_user = User.find_by_login_or_email(@user_session.login)
     unless @login_user == nil
       unless @login_user.crypted_password == nil or @login_user.crypted_password == ""      
         if @user_session.save and @login_user.is_approved == 1 and @login_user.confirmed == true      
            @current_user = current_user
            @role_id = @current_user.role_id      
            if @role_id == 1 || @role_id == 2
              redirect_to :action=>:workflow, :controller=>:welcome
            elsif @role_id == 3
              redirect_to :action=>:index, :controller=>:questions
            else
              redirect_to :action=>:index, :controller=>:attend_exams, :user=>@current_user.id
            end
          elsif @login_user.active == false
            flash[:error] = t('login.inactive')
            redirect_to :back
          elsif @login_user.is_approved == 1 and @login_user.confirmed == false
            flash[:error] = t('login.please_verify_email')
            redirect_to :back
          elsif @login_user.is_approved == 2 and @login_user.confirmed == false
            flash[:error] = t('login.login_rejected')
            redirect_to :back
          else
            flash[:error] = t('login.error')
            redirect_to :back
          end      
      else
        flash[:error] = t('login.please_verify_email')
        redirect_to :back
      end
    else
        flash[:error] = t('login.error')
        redirect_to :back
    end
  end
 
  def destroy
     unless current_user_session == nil
      current_user_session.destroy
      flash[:success] = t('login.logout')
      redirect_back_or_default root_url
     else
      redirect_to :back
     end
  end
  

end