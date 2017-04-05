require 'spec_helper'

describe User do 
  it { is_expected.to validate_presence_of(:username) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password).on(:create) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to validate_uniqueness_of(:username) }
  it { is_expected.to validate_length_of(:password).is_at_least(8).on(:create) } 
  it { is_expected.to have_many :reviews }
  it { is_expected.to have_many(:queue_items).order('ranking ASC') }
  
  it_behaves_like "tokenable" do 
    let(:object) { Fabricate(:user) }
  end
  
  describe "#follows?" do 
    let(:user1) { Fabricate(:user) } 
    let(:user2) { Fabricate(:user) }
    
    it "returns true if user has a following relationship with another user" do 
      Fabricate(:relationship, follower: user1, leader: user2)
      expect(user1.follows?(user2)).to be_truthy
    end
    
    it "returns false if user does not have a following relationship with another user" do 
      expect(user1.follows?(user2)).to be_falsy
    end
  end
end