class PagesController < ApplicationController

  def index
    redirect_to basic_info_index_path and return if current_user
    render layout: 'homepage'
  end

  def about_us
  end

  def youtube
    redirect_to "https://www.youtube.com/watch?v=Y3VtnlOD3Uk"
  end
end
