class Scraper

  CONTENT_TAG = {
    "medium.com":           ".postArticle-content",
    "espn.go.com":          ".article",
    "www.npr.org":          "#storytext p",
    "www.cnn.com":          "#body-text",
    "news.fastcompany.com": ".first-item",
    "www.fastcompany.com":  "article",
    "www.wired.com":        "article",
    "www.theatlantic.com":  "#article-section-1",
    "nypost.com":           ".entry-content",
    "www.bbc.com":          ".story-body__inner",
    "kotaku.com":           ".post-content",
    "pitchfork.com":        ".contents"
  }

  attr_accessor :url, :domain, :text, :title, :doc, :doc_body

  def initialize(url)
    @url = url
    self.url_check
    self.nokogiri_doc
    self.scrape_nokogiri_doc_tags
    self.get_title
    self.get_nokogiri_doc_body
    self.remove_tags
    self.scrape_text
    self.custom_text_scrape
    # doc_body attr is now just text body container

    self.white_space_cleaner
    self.text_length
  end

  def url_check
    @domain = get_domain(self.url)
    if @domain == "medium.com"
      @url.gsub!(/#.*\z/, '')
    end
  end

  def nokogiri_doc
    @doc   = Nokogiri::HTML(open(url))
  end

  def scrape_nokogiri_doc_tags
    if @domain == "www.npr.org"
      doc.search(".credit-caption").each { |caption| caption.remove }
      doc.search(".caption").each { |caption| caption.remove }
    end
  end

  def get_title
    @title = doc.search('head').search('title').text
  end

  def custom_text_scrape
    if @domain == "www.cnn.com"
      @text.gsub!(/Story highlights.+\(CNN\)/, " ")
    end
  end

  def get_domain(url)
    uri    = URI.parse(url)
    domain = uri.host
  end

  def get_nokogiri_doc_body
    tag   = CONTENT_TAG[domain.to_sym]
    @doc_body = doc.css(tag)
  end

  def remove_tags
    doc_body.search("style").each { |style| style.remove }
    doc_body.search("script").each { |script| script.remove }
  end

  def scrape_text
    first_sentence = doc_body.text.match(/\.*./)
    if first_sentence
      @text = doc_body.text
    else
      @text = title + " " + doc_body.text
    end
  end

  def white_space_cleaner
    self.text.gsub!(/\s+/, " ")
  end

  def text_length
    if text.length > 5000
      @text = text[0,4999]
    end
  end
end

