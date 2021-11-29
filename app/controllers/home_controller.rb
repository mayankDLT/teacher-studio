=begin
  home_controller.rb
  Description: Controller file for managing the home page of the application.
  Created on: October 11, 2010
  Last modified on: March 18, 2013
  Copyright 2013 PIT Solutions Pvt. Ltd. All Rights Reserved.
=end

class HomeController < ApplicationController
   
  def index
    if t('language.lang') == "en"
      @aboutus = Aboutus.find_by_locale_id(1)
    elsif t('language.lang') == "de"
      @aboutus = Aboutus.find_by_locale_id(2)
    elsif t('language.lang') == "ar"
      @aboutus = Aboutus.find_by_locale_id(3)
    elsif t('language.lang') == "zh"
      @aboutus = Aboutus.find_by_locale_id(4)
    end
  end
  
  def view_aboutus
    @aboutus_english = Aboutus.find_by_locale_id(1)
    @aboutus_german = Aboutus.find_by_locale_id(2)
    @aboutus_arabic = Aboutus.find_by_locale_id(3)
    @aboutus_chinese = Aboutus.find_by_locale_id(4)
  end
  
  def view_clients
    @clients = Clientinfo.order('created_at desc')
  end
  
  def view_features
    
  end
  
  def veiw_modules
    
  end
  
  def view_contactus
    
  end
 
end
