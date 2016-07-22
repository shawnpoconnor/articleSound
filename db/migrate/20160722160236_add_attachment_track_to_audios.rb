class AddAttachmentTrackToAudios < ActiveRecord::Migration
  def self.up
    add_attachment :audios, :track
  end

  def self.down
    remove_attachment :audios, :track
  end
end
