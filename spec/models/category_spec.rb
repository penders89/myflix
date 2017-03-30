require 'spec_helper'

describe Category do 
  it { is_expected.to validate_presence_of(:name) } 
  it { is_expected.to have_many(:videos).order('created_at DESC') }
  
  describe "recent_videos" do 
    let(:category) { Fabricate(:category) }
    
    it "should return an empty array if there are no videos" do 
      expect(category.recent_videos).to eq([])
    end
    
    it "should return an array of one if there is one video" do 
      video = Fabricate(:video, category: category) 
      expect(category.recent_videos).to eq([video])
    end
    
    it "should only return an array of six if there are more than six videos" do 
      7.times do 
        Fabricate(:video, category: category)
      end
      expect(category.recent_videos.count).to eq(6)
    end
      
    
    it "should return array in reverse chronological order" do 
      video1 = Fabricate(:video, category: category, created_at: 2.days.ago)
      video2 = Fabricate(:video, category: category, created_at: 1.days.ago)
      expect(category.recent_videos).to eq([video2, video1])
    end
    
  end
end