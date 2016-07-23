class Audio < ApplicationRecord

  has_attached_file :track
  # validates_attachment_content_type :track, :content_type => "audio/ogg"
  validates_attachment_content_type :track, content_type: "audio/x-opus+ogg"
  # before_post_process :set_content_type

  def set_content_type
    self.my_attachment.instance_write(:content_type, MIME::Types.type_for(self.track).to_s)
  end
end
