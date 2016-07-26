class Article < ApplicationRecord
  has_many :user_articles
  has_many :users, through: :user_articles, dependent: :destroy
  has_one :audio

  validates :text, presence:true, uniqueness:true
  validates :url, presence:true, uniqueness:true
  validates :domain, presence:true

  def call_watson
    response = `curl -g -X POST -u \"#{ENV['WATSON_CREDS_USERNAME']}\":\"#{ENV['WATSON_CREDS_PASSWORD']}\" --header \"Content-Type:application/json\" --header \"Accept:audio/ogg\" --data \"{\\"text\\": \\"#{self.text}\\"}\" --output tmp/article#{self.id}.ogg \"https://stream.watsonplatform.net/text-to-speech/api/v1/synthesize?voice=en-US_AllisonVoice\"`
  end

  def delete_file
    File.delete("tmp/article#{self.id}.ogg")
  end

  def readers
    return self.user_articles.count
  end

  def self.top_five
    Article.all.sort{ |x, y| y.readers <=> x.readers }[0..4]
  end
end
