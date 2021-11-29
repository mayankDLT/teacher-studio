=begin 
  subcategory_controller.rb
  Description: Controller file for managing the sub-categories in Blog feature.
  Created on: April 13, 2012
  Last modified on: October 10, 2012
  Copyright 2013 PIT Solutions Pvt. Ltd. All Rights Reserved.
=end

class SubcategoryController < ApplicationController
  #filter_access_to :all
  layout 'blog'
  
  before_filter :only_admin
  def index
  end

  def list
    @page_title = t('subcategory.view_all_title')
    if params[:sort].blank? || params[:sort] == "all"
      @subcategories = Subcategory.order("id desc")
    else
      @subcategories = search(Subcategory, params[:sort])
    end
  end
  
  def new
    @subcategory = Subcategory.new
    @page_title = t('subcategory.new_title')
  end
  
  def save
    @subcategory = Subcategory.new(params[:subcategory])
    if @subcategory.save
      flash[:success] = t('subcategory.create')
      redirect_to :action => :list
    else
      render :new
    end
  end
  
  def only_admin
    if current_user
      if current_user.role_id == 1
        return true
      else
        store_location
        flash[:notice] = t('subcategory.not_allowed_notice')
        redirect_to :action=>:blog, :controller=>"blog_category"       
        return false
      end
    end
  end
  
  def destroy
    @subcategory = Subcategory.find(params[:id])
    if  @subcategory.destroy
      flash[:success] = t('subcategory.delete')
      respond_to do |format|
      format.html { redirect_to :action => "list" }
      format.js
      end
    else
      redirect_to :action => "list"
    end
  end  
  
  def edit
    @subcategory = Subcategory.find(params[:id])
    @page_title = t('article_new.edit_subcategory')
  end 
  
  def update
    @subcategory = Subcategory.find(params[:id])
    if @subcategory.update_attributes(params[:subcategory])
      flash[:success] = t('subcategory.update')
      redirect_to :action => :list
    else
      render :edit 
    end

  end  
  
end
