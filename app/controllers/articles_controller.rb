class ArticlesController < ApplicationController
  def new
  end

  def create
    @article = Article.find_or_initialize_by(article_params)
    
    if @article.valid?
      redirect_to current_user 
      return
    end

    scraper = Scraper.new(@article.url)
    @article.text = scraper.text
    @article.domain = scraper.domain
    @article.title = scraper.title
    if @article.save
      @article.call_watson
      @audio = Audio.create!(article: @article, track: File.open("#{Rails.root}/app/assets/audio/article#{@article.id}.ogg"))
      @article.aws_url = @audio.track.url
      @article.save
      render 'articles/show'
    else
      flash[:notice]="Invalid URL."
      redirect_to current_user
    end
  end

  def show
    @article = Article.find_by(id: params[:id])
    @audio = @article.audio
    render 'articles/show'
  end

private

  def article_params
    params.require(:article).permit(:url)
  end
end
