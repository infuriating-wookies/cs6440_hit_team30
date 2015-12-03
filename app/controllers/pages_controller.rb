class PagesController < ApplicationController

  def index
    redirect_to basic_info_index_path and return if current_user
    render layout: 'homepage'
  end

  def about_us
  end

  def youtube
    redirect_to "https://www.youtube.com/watch?v=8ctnbq6tfU0&feature=youtu.be"
  end
end
