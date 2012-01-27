class ArticleController < ApplicationController
  def index
    render :layout => 'index'
  end

  def read
    @read_status = ReadStatus.new(:article_id => params[:id], :user_id => @current_user.id)

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
end
