require 'spec_helper'

describe QueueItem do 
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :video }
  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :video }
  it { is_expected.to validate_presence_of :ranking }
  it { is_expected.to validate_numericality_of(:ranking).only_integer }
  
  describe "#rating" do 
    it "returns rating from review when review is present" do 
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, user: user, video: video, rating: 4)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(review.rating)
    end
    
    it "returns nil when review is not present" do 
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(nil)
    end
  end
  
  describe "#rating=" do 
    it "changes rating if review is present" do 
      user = Fabricate(:user)
      video = Fabricate(:video)
      review = Fabricate(:review, user: user, video: video, rating: 2)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = 4
      expect(Review.first.rating).to eq(4)
    end
    
    it "clears the rating of the review if the review is present" do 
      user = Fabricate(:user)
      video = Fabricate(:video)
      review = Fabricate(:review, user: user, video: video, rating: 2)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = nil
      expect(Review.first.rating).to eq(nil)
    end
    
    it "creates a review with the rating if review is not present" do 
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = 3
      expect(Review.first.rating).to eq(3)
    end
    
  end
end