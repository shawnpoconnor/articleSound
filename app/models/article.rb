class Article < ApplicationRecord
  has_many :user_articles
  has_many :users, through: :user_articles

  validates :text, presence:true, uniqueness:true
  validates :url, presence:true, uniqueness:true
  validates :domain, presence:true

  after_save :url_check

  CONTENT_TAG = { "medium.com": ".postArticle-content",
                "espn.com": ".article",
                "npr.org": ".story"
                }

  def url_check
    @domain = domain(self.url)
    if @domain == "medium.com"
      self.url.gsub!(/#.*\z/, '')
    end
  end

  def domain(url)
    uri = URI.parse(url)
    domain = uri.host
  end

  def text
    tag = CONTENT_TAG[domain]
    doc = Nokogiri::HTML(open(url))
    @text = doc.css(tag).text
  end

end
