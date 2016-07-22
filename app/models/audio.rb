class Audio < ApplicationRecord

  has_attached_file :track
  validates_attachment_content_type :track, :content_type => "audio/ogg"

end
