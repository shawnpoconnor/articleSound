class UserArticlesController < ApplicationController
  def destroy
    article = Article.find(params[:id])
    UserArticle.find_by(article_id: article.id, user_id:current_user.id).destroy
    redirect_to current_user
  end
end
