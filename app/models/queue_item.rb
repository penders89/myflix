class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  
  validates_presence_of :user
  validates_presence_of :video
  validates_presence_of :ranking
  
  validates_numericality_of :ranking, { only_integer: true }
  
  def rating
    review = Review.where(user_id: user.id, video_id: video.id).first
    review.rating if review
  end
  
  def rating=(new_rating)
    review = Review.where(user_id: user.id, video_id: video.id).first
    if review 
      review.update_column(:rating, new_rating)
    else 
      Review.create(user: user, video: video, rating: new_rating)
    end
  end
  
  private 
  
    def review
      @review ||= Review.where(user_id: user.id, video_id: video.id).first
    end
end