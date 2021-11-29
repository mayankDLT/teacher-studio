=begin
  article_controller.rb
  Description: Controller file for managing the articles in Blog feature.
  Created on: April 09, 2012
  Last modified on: October 10, 2012
  Copyright 2013 PIT Solutions Pvt. Ltd. All Rights Reserved.
=end

class ArticleController < ApplicationController
  #filter_access_to :all, :except => :index
  layout 'blog'
  before_filter :require_user, :only=>[:new]
  #before_filter :require_no_user,:except=>:index
  def index
    @article = Article.find_by_title(params[:articles])
    @comment=@article.comments.new
    @page_title = @article.title
    respond_to do |format|
      format.html # index.html.erb
      format.rss { render :layout => false }
    end
  end
  
  def show
    @article = Article.find_by_id(params[:id])
    @comment=@article.comments.new
    @page_title = @article.title
    respond_to do |format|
      format.html # index.html.erb
      format.rss { render :layout => false }
    end
  end
  
  
  def new
    @article = Article.new
    @page_title = t('article_new.new_article')
    @subcategories = []
  end

  def save
    @article = Article.new(params[:article])
    if @article.save
      flash[:success] = t('blog.success_save')
      redirect_to :action=>:list
    else
      @page_title = t('article_new.new_article')
      @subcategories = []
      render :new
    end
  end

  def comment
    @article_id = params[:comments][:article_id]
    @article = Article.find_by_id(@article_id.to_i)
    @comment = @article.comments.new(params[:comment]) 
    if @comment.save
      @comment = @article.comments.new
    end
    #redirect_to :back      
  end

  def edit
    @article = Article.find(params[:id])
    @category = BlogCategory.find_by_id(@article.blog_category_id)
    unless @category==nil
    @subcategories = @category.subcategories
  else
    @subcategories = []
    end
    @page_title = t('article_new.edit_article')
  end

  def update
    @article = Article.find(params[:id])
    if @article.update_attributes(params[:article])
      flash[:success] = t('blog.success_update')
      redirect_to :action => :list
    else
      render :edit
    end
  end
  
  def delete
    @article = Article.find(params[:id])
    @article.destroy
    flash[:success] = t('blog.success_delete')
    redirect_to :back
  end
  
  def list
     @page_title = t('blog.title_list_artciles')
     if params[:sort].blank? || params[:sort] == "all"
      @articles = Article.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
     else
      @articles = search(Article, params[:sort])
     end
  end

  def news
    @article = Article.paginate(:page => params[:page], :per_page => 10, :order => "created_at desc")
  end
  
  def getBlogcategory
   
     @blogCategory_id = params[:category_id]
   
    unless @blogCategory_id == nil or params[:category_id].to_i == 0
     @blogCategory = BlogCategory.find_by_id(params[:category_id].to_i)
     @subcategories = @blogCategory.subcategories  

     else
    @subcategories = []
    end
    render :json => {:subcategories=>@subcategories}     
  end

  def thumbsUp
    @article_user = ArticleRating.find_by_article_id_and_user_id(params[:article_id],params[:user_id])
    if @article_user.blank?
      @article_id = params[:article_id]
      @article_rating = ArticleRating.new
        if current_user
          @article_rating.user_id = current_user.id
        end
      @article_rating.article_id = @article_id
      @article_rating.rating = 1
      @article_rating.save
      render :text => true
    else
      render :text => false
    end
  end  
  
  def thumbsDown
    @article_user = ArticleRating.find_by_article_id_and_user_id(params[:article_id],params[:user_id])
    if @article_user.blank?    
      @article_id = params[:article_id]
      @article_rating = ArticleRating.new
        if current_user
          @article_rating.user_id = current_user.id
        end
      @article_rating.article_id = @article_id
      @article_rating.rating = 0
      @article_rating.save
      render :text => true
    else
      render :text => false
    end
  end
  
  def delete_comment
    @comment = Comment.find_by_id(params[:id].to_i)
    @comment.destroy
    @article_id = params[:article_id]
    @article = Article.find_by_id(@article_id.to_i)
    
    #redirect_to :back
  end
 
end
