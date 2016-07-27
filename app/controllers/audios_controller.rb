class AudiosController < ApplicationController

  def new
    @audio = Audio.new
  end


  def create
    @audio = Audio.new(audio_params)
    if @audio.save
      redirect_to @audio
    else
      @errors = @audio.errors.full_messages
      render 'new'
    end
  end

  def show
  end

private
  def audio_params
    params.require(:audio).permit(:track)
  end

end









  def create
    @article = Article.find_or_initialize_by(article_params)

    respond_to do |format|
      if @article.valid?
        userart = UserArticle.find_or_initialize_by(user:current_user, article:@article)
        if userart.save
          @queue = current_user.user_articles.where(listened: false).order("created_at DESC").limit(5)
          format.html { redirect_to current_user, notice: "#{@article.title} added to queue"}
          format.json render partial: "/users/queue", layout: false, queue: @queue
        else
          format.html { redirect_to current_user, notice: "Article already in your queue/history" }
          format.json render :json => { :error => "Article already in your queue/history." }.to_json, status: 422
        end
      else
        scraper = Scraper.new(@article.url)
        if scraper.valid_url?
          scraper.scrape
          @article.text = scraper.text
          @article.domain = scraper.domain
          @article.title = scraper.title
        end
        if @article.save
          # binding.pry
          # @article.call_watson
          # @audio = Audio.create!(article: @article, track: File.open("#{Rails.root}/tmp/article#{@article.id}.ogg") )
          # UserArticle.create(user:current_user, article:@article)
          # @article.delete_file
          # Testing for not using Watson calls
          @audio = Audio.create!(article: @article, track: File.open("article12.ogg") )
          UserArticle.create(user:current_user, article:@article)
          format.html { redirect_to current_user, notice: "#{@article.title} added to your queue" }
          @queue = current_user.user_articles.where(listened: false).order("created_at DESC").limit(5)
          format.json render partial: "/users/queue", queue: @queue
        else
          format.html { redirect_to current_user, notice: scraper.text }
          format.json { render json: { error: scraper.text }.to_json, status: 422 }
        end
      end
    end
  end
