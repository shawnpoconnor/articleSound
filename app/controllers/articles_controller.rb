class ArticlesController < ApplicationController
  def new
  end

  def create
    @article = Article.find_or_initialize_by(article_params)
    if @article.valid?
      @user = current_user
      render 'users/show'
    end

    scraper = Scraper.new(@article.url)
    @article.text = scraper.text
    @article.domain = scraper.domain

    if @article.save && scraper.text != "ERROR"
      @article.call_watson
      @audio = Audio.create!(track: File.open("#{Rails.root}/app/assets/audio/article#{@article.id}.ogg"))
      @article.aws_url = @audio.track.url
      @article.save
      render 'articles/show'
    else
      flash[:notice]="Invalid URL or unsupported website."
      redirect_to current_user
    end
  end

  def show
    @article = Article.find_by(id: params[:id])
    render 'articles/show'
  end

private
  
  def article_params
    params.require(:article).permit(:url)
  end
end
