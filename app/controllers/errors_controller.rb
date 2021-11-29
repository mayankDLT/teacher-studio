=begin
  errors_controller.rb
  Description: Controller file for handling errors or exceptions.
  Created on: January 11, 2011
  Last modified on: October 29, 2012
  Copyright 2013 PIT Solutions Pvt. Ltd. All Rights Reserved.
=end

class ErrorsController < ApplicationController
  
    ERRORS = [
    :internal_server_error,
    :not_found,
    :unprocessable_entity
  ].freeze
  
  ERRORS.each do |e|
    define_method e do
      respond_to do |format|
        format.html { render e, :status => e }
        format.any { head e }
      end
    end
  end
  
  def not_found
  end

end
