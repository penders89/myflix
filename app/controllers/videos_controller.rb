class VideosController < ApplicationController 
  def index
    @categories = Category.all
  end
  
  def show
    @video = Video.find(params[:id])
    @review = Review.new
    @reviews = @video.reviews.order('created_at DESC')
  end
  
  def search
    @videos = Video.search_by_title(params[:search_string])
  end
  
end