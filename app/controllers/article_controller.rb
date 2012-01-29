class ArticleController < ApplicationController
  def index
    render :layout => 'index'
  end

  def read
    article_id = params[:id]

    if Article.read_by_user?(article_id, @current_user)
      p 'hi'
    end

    return

    if @read_status.save
      respond_to do |format|
        format.json { render :json => { :success => true } }
      end
    else
      respond_to do |format|
        format.json { render :json => { :success => false } }
      end
    end
  end

  def hearted
    
  end
end
