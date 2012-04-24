class ArticlesController < ApplicationController
  respond_to :json
  layout nil

  def index
    @articles = Article.limit(50)
  end

  def show
    @article = Article.find(params[:id])
  end

  def create
    
  end

  def update
    
  end

  def destroy
    
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
      r[:success] = current_user.read_article(article)
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
      r[:success] = current_user.like_article(article)
    end

    respond_to do |format|
      format.json { render :json => r }
    end
  end

end