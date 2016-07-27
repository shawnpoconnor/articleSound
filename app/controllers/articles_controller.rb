class ArticlesController < ApplicationController
  def new
  end

  def create
    @article = Article.find_or_initialize_by(article_params)

    if @article.valid?
      userart = UserArticle.find_or_initialize_by(user:current_user, article:@article)
      if userart.save
        if request.xhr?
          @queue = current_user.user_articles.where(listened: false).order("created_at DESC").limit(5)
          render partial: "/users/queue", queue: @queue
        else
          redirect_to current_user
        end
      else
        if request.xhr?
          render :json => { :error => "Article already in your queue/history." }.to_json, status: 422
        else
          flash[:notice] = "Article already in your queue/history."
          redirect_to current_user
        end
      end
    else
      scraper = Scraper.new(@article.url)
      if scraper.valid_url?
        scraper.scrape
        @article.text = scraper.text
        @article.domain = scraper.domain
        @article.title = scraper.title
      end
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
      if request.xhr?
        @queue = current_user.user_articles.where(listened: false).order("created_at DESC").limit(5)
        render partial: "/users/queue", queue: @queue
      else
        redirect_to current_user
      end
    else
      if request.xhr?
        binding.pry
        render :json => { :error => scraper.text }.to_json, status: 422
      else
        flash[:notice]=scraper.text
        redirect_to current_user
      end
    end
  end

  # def create
  #   @article = Article.find_or_initialize_by(article_params)

  #   respond_to do |format|
  #     if @article.valid?
  #       userart = UserArticle.find_or_initialize_by(user:current_user, article:@article)
  #       if userart.save
  #         @queue = current_user.user_articles.where(listened: false).order("created_at DESC").limit(5)
  #         format.html { redirect_to current_user, notice: "#{@article.title} added to queue"}
  #         format.json { render partial: "/users/queue", queue: @queue }
  #       else
  #         format.html { redirect_to current_user, notice: "Article already in your queue/history" }
  #         format.json { render :json => { :error => "Article already in your queue/history." }.to_json, status: 422 }
  #       end
  #     else
  #       scraper = Scraper.new(@article.url)
  #       if scraper.valid_url?
  #         scraper.scrape
  #         @article.text = scraper.text
  #         @article.domain = scraper.domain
  #         @article.title = scraper.title
  #       end
  #       if @article.save
  #         # binding.pry
  #         # @article.call_watson
  #         # @audio = Audio.create!(article: @article, track: File.open("#{Rails.root}/tmp/article#{@article.id}.ogg") )
  #         # UserArticle.create(user:current_user, article:@article)
  #         # @article.delete_file
  #         # Testing for not using Watson calls
  #         @audio = Audio.create!(article: @article, track: File.open("article12.ogg") )
  #         UserArticle.create(user:current_user, article:@article)
  #         @queue = current_user.user_articles.where(listened: false).order("created_at DESC").limit(5)
  #         format.html { redirect_to current_user, notice: "#{@article.title} added to your queue" }
  #         format.json { render partial: "/users/queue", queue: @queue }
  #       else
  #         format.html { redirect_to current_user, notice: scraper.text }
  #         format.json { render json: { error: scraper.text }.to_json, status: 422 }
  #       end
  #     end
  #   end
  # end

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
