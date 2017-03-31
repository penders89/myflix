class ReviewsController < ApplicationController
  def create
    @video = Video.find(params[:video_id])
    @reviews = @video.reviews
    @review = Review.new(review_params)
    @review.video = @video
    @review.user = current_user
    
    if @video.reviews.map(&:user).include?(current_user)
      flash.now[:danger] = "You can only review a video once."
      render 'videos/show'
    else 
      if @review.save 
        flash[:success] = "Thanks for your review."
        redirect_to video_path(@video)
      else 
        flash.now[:danger] = "Review must have a rating."
        render 'videos/show'
      end
    end
  end
  
  private 
  
    def review_params
      params.require(:review).permit(:rating, :content)
    end
  
  
end