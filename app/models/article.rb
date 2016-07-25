class Article < ApplicationRecord
  has_many :user_articles
  has_many :users, through: :user_articles, dependent: :destroy
  has_one :audio

  validates :text, presence:true, uniqueness:true
  validates :url, presence:true, uniqueness:true
  validates :domain, presence:true

  BASE_URL =

  def call_watson
    # binding.pry
    #foo = tempfile.new(with the name of the file)
    #foo_path  =tempfile.path
    #curl --output foo_path
    #return foo_path

    # response = `curl -g -X POST -u \"#{ENV['WATSON_CREDS_USERNAME']}\":\"#{ENV['WATSON_CREDS_PASSWORD']}\" --header \"Content-Type:application/json\" --header \"Accept:audio/ogg\" --data \"{\\"text\\": \\"#{self.text}\\"}\" --output app/assets/audio/article#{self.id}.ogg \"https://stream.watsonplatform.net/text-to-speech/api/v1/synthesize?voice=en-US_AllisonVoice\"`

    # foo = Tempfile.new("article#{self.id}")
    # foo_path = foo.path
    response = `curl -g -X POST -u \"#{ENV['WATSON_CREDS_USERNAME']}\":\"#{ENV['WATSON_CREDS_PASSWORD']}\" --header \"Content-Type:application/json\" --header \"Accept:audio/ogg\" --data \"{\\"text\\": \\"#{self.text}\\"}\" --output tmp/article#{self.id}.ogg \"https://stream.watsonplatform.net/text-to-speech/api/v1/synthesize?voice=en-US_AllisonVoice\"`

  end

  def delete_file
    File.delete("tmp/article#{self.id}.ogg")
  end

  # def zacks_watson
  #   req = HTTParty.post('https://stream.watsonplatform.net/text-to-speech/api/v1/synthesize?voice=en-US_AllisonVoice',
  #                       basic_auth: {username: '53acf865-ca66-483f-8be6-066bf827f10c' , password: 'rzE28zAPKJT6' },
  #                       headers: { "Content-Type" => "application/json"},
  #                       body: {text: "hello world."}.to_json )


  # end


end
