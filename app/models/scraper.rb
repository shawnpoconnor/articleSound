require 'open-uri'
require 'nokogiri'
require 'pry'
class Scraper
  CONTENT_TAG = { "medium.com":  ".postArticle-content",
                  "espn.go.com": ".article",
                  "www.npr.org": ".story",
                  "www.cnn.com": "#body-text"
                  "www.bbc.com": ".story-body__inner"
                }

  attr_reader :url, :domain, :text

  def initialize(url)
    @url = url
    self.url_check
    self.scrape_text
    self.white_space_cleaner
    self.text_length
  end

  def url_check
    @domain = get_domain(self.url)
    if @domain == "medium.com"
      @url.gsub!(/#.*\z/, '')
    end
  end

  def get_domain(url)
    uri    = URI.parse(url)
    domain = uri.host
  end

  def scrape_text
    tag   = CONTENT_TAG[domain.to_sym]
    doc   = Nokogiri::HTML(open(url))
    @text = doc.css(tag).text
  end

  def white_space_cleaner
    self.text.gsub!(/\s{2,}|\\n/, " ")
    self.text.gsub!(/\s+/, " ")
    self.text.gsub!(/<a\s\S+">|<\/a>/, " ")
  end

  def text_length
    if text.length > 5000
      @text = text[0,4999]
    end
  end
end
