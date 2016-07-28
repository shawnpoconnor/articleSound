# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.
User.destroy_all
Article.destroy_all
Audio.destroy_all
admins = []
brun = User.create(username:"brianlee", password:"password12345", email:"bklee@email.com")
shawno = User.create(username:"shawno", password:"bigoldbrian1", email:"email@email.com")
kitty = User.create(username:"kittykat", password:"password12345", email:"kitty@email.com")
admins << brun
admins << shawno
admins << kitty
users = []

10.times do
  user = User.new( username:Faker::Name.first_name,
                        password:"password12345",
                        email:Faker::Lorem.word + "@email.com")
  if user.valid?
    user.save
    users << user
  end
end

urls= [ "http://www.cnn.com/2016/07/26/opinions/why-terrorist-attacks-opinion-peter-bergen/index.html",
        "http://kotaku.com/the-new-sonic-the-hedgehog-game-is-reimagined-old-sonic-1784168746",
        "https://medium.com/@ICRC/life-and-loss-in-south-sudan-165eaad7107e#.nohhkewuo",
        "http://espn.go.com/nfl/story/_/id/17150906/pete-carroll-seattle-seahawks-agree-contract-extension",
        "http://www.npr.org/2016/07/24/487242426/bernie-sanders-dnc-emails-outrageous-but-not-a-shock",
        "http://www.cnn.com/2016/07/10/opinions/hillary-clinton-biography-carl-bernstein/index.html",
        "http://www.fastcompany.com/3062234/tim-cooks-apple/four-reasons-why-betting-against-apple-is-a-fools-game",
        "http://kotaku.com/twitch-streamer-swatted-while-playing-pokemon-go-outsid-1784309781",
        "http://www.npr.org/2016/07/26/487550122/bill-clinton-to-headline-second-day-of-the-democratic-national-convention",
        "http://espn.go.com/nba/story/_/id/17145557/the-orlando-magic-fighting-become-viable-again",
        "https://medium.com/@stevemagness/no-one-really-wants-a-whistle-blower-russia-the-ioc-and-doping-6c0c2461bba7#.grgp7g5yj",
        "http://www.wired.com/2016/07/welcome-bizarro-world-trump-supporters-reddit/",
        "https://www.wired.com/2016/07/tesla-gigafactory-elon-musk/",
        "http://www.cnn.com/2016/07/27/us/baltimore-freddie-gray-prosecutor/index.html",
        "http://www.theatlantic.com/business/archive/2016/07/paygap-discrimination/492965/",
        "http://www.theatlantic.com/business/archive/2016/07/the-visa-for-people-officially-deemed-extraordinary/493130/",
        "http://nypost.com/2016/07/27/hero-cops-drove-off-with-ticking-bomb-to-protect-bystanders/",
        "https://www.washingtonpost.com/politics/trump-invites-russia-to-meddle-in-the-us-presidential-race-with-clintons-emails/2016/07/27/a85d799e-5414-11e6-b7de-dfe509430c39_story.html?hpid=hp_hp-top-table-main_russiacampaign-420pm%3Ahomepage%2Fstory",
        "https://www.washingtonpost.com/world/turkish-authorities-to-shut-down-dozens-of-media-outlets/2016/07/27/d1c8454c-542e-11e6-b652-315ae5d4d4dd_story.html?hpid=hp_hp-more-top-stories_ap-turkey-505pm%3Ahomepage%2Fstory",
        "http://www.theonion.com/article/wow-dad-really-went-zero-60-woodworking-summer-53349",
        "http://www.theonion.com/article/nasa-announces-bold-plan-still-exist-2045-50398"
      ]

articles = []
urls.each do |url|
  scraper = Scraper.new(url)
  scraper.scrape
  user = admins.sample
  article = user.articles.create(text: scraper.text, url:url, domain:scraper.domain, title:scraper.title)
  articles << article
  article.call_watson
  Audio.create!(article: article, track: File.open("#{Rails.root}/tmp/article#{article.id}.ogg"))
  article.delete_file
end

users.each do |user|
  5.times do
    userart = UserArticle.new(user: user, article: articles.sample)
    if userart.valid?
      userart.save
    end
  end
end
