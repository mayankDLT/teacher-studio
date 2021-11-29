class BlogCategory < ActiveRecord::Base
  attr_accessible :name
  has_many :articles, :dependent => :destroy
  has_many :subcategories, :dependent => :destroy
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def getSubcategories(category)
    @category = BlogCategory.find_by_id(category.id)
    @subcategories = @category.subcategories
    return @subcategories
  end
  
  def getArticles(category)
    @category = BlogCategory.find_by_id(category.id)
    @articles = @category.articles
    return @articles   
  end
  
  def getSubcategoryArticle(subcategory)
    @subcategory = Subcategory.find_by_id(subcategory.id)
    @articles = @subcategory.articles    
    return @articles
  end
end
