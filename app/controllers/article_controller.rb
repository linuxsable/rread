class ArticleController < ApplicationController
  def index
    render :layout => 'index'
  end

  # For reading an article by the current user.
  def read
    r = { :success => false }

    begin
      article = Article.find(params[:id])  
    rescue Exception => e
      r[:error] = "Article not found"
    end

    if article.is_a? Article
      r[:success] = current_user.user_model.read_article(article)
    end

    respond_to do |format|
      format.json { render :json => r }
    end
  end

  # For liking an article by the current user.
  def like
    r = { :success => false }

    begin
      article = Article.find(params[:id])  
    rescue Exception => e
      r[:error] = "Article not found"
    end

    if article.is_a? Article
      r[:success] = current_user.user_model.like_article(article)
    end

    respond_to do |format|
      format.json { render :json => r }
    end
  end

end