class Audio < ApplicationRecord
  belongs_to :article
  has_attached_file :track
  # validates_attachment_content_type :track, :content_type => "audio/ogg"
  validates_attachment_content_type :track, content_type: "audio/x-opus+ogg"

  after_post_process :save_url

  def save_url
    article_id = self.track_file_name.match(/\d+/).to_s.to_i
    article = Article.find_by(id: article_id)
    # binding.pry
    # article.aws_url = self.track.url
    # article.save
  end

end
