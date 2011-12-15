# This will be for logged in users only
class HomeController < ApplicationController
  def index
    # Get the current users Reader
    
    # pp current_user
    current_user.reader
    
    # Update the reader by pulling in all blog posts
    
    # Render the reader
  end
end
