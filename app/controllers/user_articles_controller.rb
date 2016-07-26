class UserArticlesController < ApplicationController
  def update
    user_article = UserArticle.find_by(article_id: params[:id], user_id:current_user.id)
    user_article.update_attributes(listened: true)
    user_article.save
  end

  def destroy
    UserArticle.find(params[:id]).destroy
    redirect_to current_user
  end
end
