class ArticlesController < ApplicationController
  def new
  end

  def create
    @article = Article.find_or_initialize_by(article_params)
    if @article.valid?
      #redirect them to the audio file
    end

    scraper = Scraper.new(@article.url)
    @article.text = scraper.text
    @article.domain = scraper.domain

    if @article.save
      @article.call_watson
      # run check for audio file received
        @audio = Audio.new(track: "/assets/audio/article#{@article.id}")
      redirect_to current_user
      #send it to watson
      #let watson save the file locally
      #upload file to s3
      #get aws url
    else
      flash[:notice]="Invalid URL."
      redirect_to current_user
    end
  end

private
  
  def article_params
    params.require(:article).permit(:url)
  end
end
