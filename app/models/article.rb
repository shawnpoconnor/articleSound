class Article < ApplicationRecord
  has_many :user_articles
  has_many :users, through: :user_articles

  validates :text, presence:true, uniqueness:true
  validates :url, presence:true, uniqueness:true
  validates :domain, presence:true
end
