class ArticlesController < ApplicationController
  def new
  end

  def create
    @article = Article.find_or_initialize_by(article_params)

    if @article.valid?
      @audio = Audio.find_by(article_id: @article.id)
      UserArticle.create(user:current_user, article:@article)
      redirect_to current_user
      return
    else
      scraper = Scraper.new(@article.url)
      @article.text = scraper.text
      @article.domain = scraper.domain
      @article.title = scraper.title
    end

    if @article.save
      # @article.call_watson
      # @audio = Audio.create!(article: @article, track: File.open("#{Rails.root}/tmp/article#{@article.id}.ogg") )
      # UserArticle.create(user:current_user, article:@article)
      # @article.delete_file
      # Testing for not using Watson calls
      @audio = Audio.create!(article: @article, track: File.open("article31.ogg") )
      UserArticle.create(user:current_user, article:@article)
      if request.xhr?
        @queue = current_user.user_articles.where(listened: false).order("created_at DESC").limit(5)
        render partial: "/users/queue", queue: @queue
      else
        redirect_to current_user
      end
    else
      if request.xhr?
        "Invalid URL"
      else
        flash[:notice]="Invalid URL."
        redirect_to current_user
      end
    end
  end

  def show
    @article = Article.find_by(id: params[:id])
    @audio = @article.audio
    redirect_to current_user
  end

private

  def article_params
    params.require(:article).permit(:url)
  end
end
