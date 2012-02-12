class ArticleController < ApplicationController
  def index
    render :layout => 'index'
  end

  def read
    article = Article.find(params[:id])
    @current_user.user_model.mark_article_as_read(article)
    respond_to do |format|
      format.json { render :json => { :success => true}}
    end
  end

  def liked

  end
end