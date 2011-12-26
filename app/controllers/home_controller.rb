# This will be for logged in users only
class HomeController < ApplicationController
  def index
    # Get the current users Reader
    reader = current_user.reader.first
    @blogs = reader.blogs
    
    # Render the reader
  end
end
