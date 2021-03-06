class UserArticlesController < ApplicationController
  def update
    user_article = UserArticle.find(params[:id])
    user_article.update_attributes(listened: true)
    user_article.save
  end

  def destroy
    UserArticle.find(params[:id]).destroy
    redirect_to current_user
  end

  def create
    @user_article = UserArticle.new(article_id: params[:user_article][:article_id], user_id: current_user.id)
    @user_article.save
    @articles = Article.top_five(current_user.id)
    if request.xhr?
      render partial: "/shared/trending", locals:{articles: @articles}
    else
      redirect_to root_url
    end
  end
end
