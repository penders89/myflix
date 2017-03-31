require 'spec_helper'

describe Video do 
  it { is_expected.to validate_presence_of(:title) } 
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to belong_to(:category) }
  it { is_expected.to have_many :reviews }
  
  describe "search_by_title" do 
    let(:video) { Fabricate(:video, title: "Abcde", created_at: 2.days.ago) }
    
    it "returns an empty array when there is no match" do 
      expect(Video.search_by_title("Cba")).to eq([])
    end
    
    it "returns an array of one video for an exact match" do 
      expect(Video.search_by_title("Abcde")).to eq([video])
    end
    
    it "returns an array of one video for a partial match" do 
      expect(Video.search_by_title("bcd")).to eq([video])
    end
    
    it "returns an array of all matches ordered by created_at" do
      second_video = Fabricate(:video, title: "XbcdX", created_at: 1.days.ago)
      expect(Video.search_by_title("bcd")).to eq([video, second_video])
    end
    
    it "returns an empty array for an empty string" do 
      expect(Video.search_by_title("")).to eq([])
    end
    
  end

end