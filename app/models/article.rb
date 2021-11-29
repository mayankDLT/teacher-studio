class Article < ActiveRecord::Base
  attr_accessible :title, :body_part, :blog_category_id, :subcategory_id, :enable_comment, :user_id
  belongs_to :user
  has_many :comments, :dependent => :destroy
  belongs_to :blog_category
  belongs_to :subcategory
  belongs_to :user 
  has_many :article_ratings, :dependent => :destroy
  validates_presence_of :title, :body_part
  validates_uniqueness_of :title
  
  def getCount_tp(article_id)
    @article_tp = ArticleRating.where(["article_id = ? and rating = ?", article_id,1])
    return @article_tp.count
  end
  
  def getCount_td(article_id)
    @article_td = ArticleRating.where(["article_id = ? and rating = ?", article_id,0])
    return @article_td.count
  end  
  
  def getPercentage(article_id)
    @total_article = ArticleRating.where(["article_id = ?", article_id])
    @article = ArticleRating.where(["article_id = ? and rating = ?", article_id,1])

    @total = @total_article.count
    @tu = @article.count

    unless @total_article.count == 0
    @percent = @tu.to_f / @total.to_f * 100
    @percentage = @percent.to_f.round(0)
    end
    return @percentage.to_i
  end
  
  def username(user_id)
    @user = User.find_by_id(user_id)
    return @user.name
  end
  
  def has_comment(article)
    @article = Article.find_by_id(article.id)
    if @article.enable_comment == true
      return true
    else
      return false
    end
  end
  
end
