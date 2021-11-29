=begin
  blog_category_controller.rb
  Description: Controller file for managing the categories in Blog feature.
  Created on: April 13, 2012
  Last modified on: October 10, 2012
  Copyright 2013 PIT Solutions Pvt. Ltd. All Rights Reserved.
=end

class BlogCategoryController < ApplicationController
  
  #filter_access_to :all, :except => :blog
  layout 'blog'
  before_filter :require_user,:except=>:blog
  before_filter :only_admin,:except=>:blog
  def blog
    @article = Article.last
    @articles = Article.order("created_at asc").last(5).reverse
    @articles.slice!(0)
    @last_five_articles = @articles
    @categories = BlogCategory.order("created_at desc")
    @comments = Comment.order("created_at asc").last(5).reverse
  end
  
  def index
    @category = BlogCategory.find_by_name(params[:category])
    @articles = @category.articles
    #@articles = Article.where(["blog_category_id = ? and subcategory_id = ?",@category.id,0])
    @page_title = @category.name
  end

  def edit
    @category = BlogCategory.find(params[:id])
    @page_title = t('article_new.edit_category')
  end

  def update
    @category = BlogCategory.find(params[:id])
    if @category.update_attributes(params[:blog_category])
      flash[:success] = t('category.update')
      redirect_to :action => :list
    else
      render :edit 
    end

  end

  def show
  end

  def new
    @page_title = t('category.new_title')
    @category = BlogCategory.new
  end

  def save
    @category = BlogCategory.new(params[:blog_category])
    if @category.save
      flash[:success] = t('category.create')
      redirect_to :action => :list
    else
      render :new
    end
  end
  
  def list
    @page_title = t('category.view_all_title')
    if params[:sort].blank? || params[:sort] == "all"
      @categories = BlogCategory.order("id desc")
    else
      @categories = search(BlogCategory, params[:sort])
    end
  end
  
  def subcategory
    @category = BlogCategory.find_by_name(params[:category])
    @subcategories = @category.subcategories
    @page_title = @category.name
  end
  
  def subcategory_article
    @subcategory = Subcategory.find_by_id(params[:subcategory_id].to_i)
    @articles = @subcategory.articles
    @page_title = @subcategory.name
  end
  
  def categoryArticle
    @category = BlogCategory.find_by_id(params[:category].to_i)
    @articles = @category.articles
  end
  
  def only_admin
    if current_user
      if current_user.role_id == 1
        return true
      else
        store_location
        flash[:notice] = t('category.not_allowed_notice')
        redirect_to :action=>:blog, :controller=>"blog_category"       
        return false
      end
    end
  end


  def destroy
    @blog_category = BlogCategory.find(params[:id])
    if  @blog_category.destroy
      flash[:success] = t('category.delete')
      respond_to do |format|
      format.html { redirect_to :action => "list" }
      format.js
      end
    else
      redirect_to :action => "list"
    end
  end

end
