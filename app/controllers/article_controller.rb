class ArticleController < ApplicationController
  def index
    render :layout => 'index'
  end

  def read
    article_id = params[:id]

    a = ArticleStatus.find_or_create_by_user_id_and_article_id(@current_user.id, article_id)
    p a

    # if @read_status.save
    #   respond_to do |format|
    #     format.json { render :json => { :success => true } }
    #   end
    # else
    #   respond_to do |format|
    #     format.json { render :json => { :success => false } }
    #   end
    # end
  end

  def liked

  end
end
