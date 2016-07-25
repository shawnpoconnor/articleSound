# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create(username:"brianlee", password:"password12345", email:"bklee@gmail.com")
urls=["http://www.cnn.com/2016/07/24/politics/obama-trump-nato-isis/index.html", "http://kotaku.com/the-new-sonic-the-hedgehog-game-is-reimagined-old-sonic-1784168746", "https://medium.com/@jarjop/my-self-driving-car-gets-lost-399f4e28a3b0#.auy2ktebn", "http://espn.go.com/olympics/basketball/story/_/id/17128421/us-men-basketball-team-tops-argentina-111-74-exhibition-game-las-vegas","http://www.npr.org/2016/07/24/487242426/bernie-sanders-dnc-emails-outrageous-but-not-a-shock"]

urls.each do |url|
  scraper = Scraper.new(url)
  text = scraper.text.gsub("\"","")
  article = user.articles.create(text: text, url:url, domain:scraper.domain, title:scraper.title)
  article.call_watson
  Audio.create!(article: article, track: File.open("#{Rails.root}/app/assets/audio/article#{article.id}.ogg"))
end
