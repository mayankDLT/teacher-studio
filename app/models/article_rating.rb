class ArticleRating < ActiveRecord::Base
  belongs_to :article
  validates_uniqueness_of :article_id, :scope => [:user_id], :message=>" already exists!" 
end
