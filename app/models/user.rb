class User < ApplicationRecord
  has_secure_password
  has_many :user_articles, dependent: :destroy
  has_many :articles, through: :user_articles

  validates :username, length: {minimum: 5, maximum:16}, uniqueness: true
  validates :email, uniqueness:true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :password, length: {minimum: 8, maximum:50}
  validates_confirmation_of :password
end
