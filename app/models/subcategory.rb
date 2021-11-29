class Subcategory < ActiveRecord::Base
  attr_accessible :name, :blog_category_id
  belongs_to :blog_category
  has_many :articles, :dependent=>:destroy

  validates_presence_of :name, :blog_category_id
  validates_uniqueness_of :name, :scope => [:blog_category_id], :message=>" already exists!"

  def getSubcategoryArticle(subcategory)
    @subcategory = Subcategory.find_by_id(subcategory.id)
    @articles = @subcategory.articles    
    return @articles
  end
end
