class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @feed_items = current_user.feed.paginate(page: params[:page])
      @micropost = current_user.microposts.build
    end
  end

  def help
  end

  def about
  	
  end

  def contact
  	
  end

  def recipe_nav
    respond_to do |format|
      format.js
      format.html
    end
  end

  def meal_nav
    
  end
end
