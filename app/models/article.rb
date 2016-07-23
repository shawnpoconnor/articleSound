class Article < ApplicationRecord
  has_many :user_articles
  has_many :users, through: :user_articles

  validates :text, presence:true, uniqueness:true
  validates :url, presence:true, uniqueness:true
  validates :domain, presence:true

  def call_watson
    response = `curl -g -X POST -u \"#{ENV['WATSON_CREDS_USERNAME']}\":\"#{ENV['WATSON_CREDS_PASSWORD']}\" --header \"Content-Type:application/json\" --header \"Accept:audio/ogg\" --data \"{\\"text\\": \\"#{self.text}\\"}\" --output app/assets/audio/article#{self.id}.ogg \"https://stream.watsonplatform.net/text-to-speech/api/v1/synthesize?voice=en-US_AllisonVoice\"`
  end

end
