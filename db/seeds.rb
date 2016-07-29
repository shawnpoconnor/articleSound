# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.
# User.destroy_all
# Article.destroy_all
# Audio.destroy_all
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

urls= [ "http://www.npr.org/sections/thetwo-way/2016/07/28/487775814/ancient-bone-shows-evidence-of-cancer-in-human-ancestor",
        "http://kotaku.com/the-new-sonic-the-hedgehog-game-is-reimagined-old-sonic-1784168746",
        "http://espn.go.com/nba/story/_/id/17138002/team-usa-too-talented-challenged-exhibition-games",
        "http://espn.go.com/nfl/story/_/id/17150906/pete-carroll-seattle-seahawks-agree-contract-extension",
        "http://www.npr.org/2016/07/24/487242426/bernie-sanders-dnc-emails-outrageous-but-not-a-shock",
        "http://espn.go.com/mlb/story/_/id/17143857/chicago-white-sox-teammates-welcome-back-chris-sale",
        "http://www.fastcompany.com/3062234/tim-cooks-apple/four-reasons-why-betting-against-apple-is-a-fools-game",
        "http://kotaku.com/twitch-streamer-swatted-while-playing-pokemon-go-outsid-1784309781",
        "http://www.cnn.com/2016/07/28/health/mystery-light-sky/index.html",
        "http://espn.go.com/nba/story/_/id/17145557/the-orlando-magic-fighting-become-viable-again",
        "http://espn.go.com/nba/story/_/id/17165522/new-york-knicks-carmelo-anthony-believe-dwyane-wade-left-miami-heat",
        "http://www.wired.com/2016/07/meet-designer-behind-cinemas-iconic-movie-titles/",
        "https://www.wired.com/2016/07/tesla-gigafactory-elon-musk/",
        "http://www.wired.com/2016/07/mtv-classic-90s-nostalgia/",
        "http://www.theatlantic.com/business/archive/2016/07/paygap-discrimination/492965/",
        "http://www.theatlantic.com/science/archive/2016/07/whats-it-like-to-see-ideas-as-shapes/492032/",
        "http://nypost.com/2016/07/27/hero-cops-drove-off-with-ticking-bomb-to-protect-bystanders/",
        "https://www.washingtonpost.com/entertainment/theater_dance/another-fanciful-oddball-gravity-defying-journey-from-cirque-du-soleil/2016/07/25/6a5cbf36-5286-11e6-bbf5-957ad17b4385_story.html?hpid=hp_hp-cards_hp-card-arts%3Ahomepage%2Fcard",
        "http://www.npr.org/sections/alltechconsidered/2016/07/28/486755823/writing-data-onto-single-atoms-scientists-store-the-longest-text-yet",
        "http://www.theonion.com/article/teen-had-absolutely-no-say-becoming-part-snapchat--53187",
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
