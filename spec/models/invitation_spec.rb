require 'spec_helper'

describe Invitation do 
  it { is_expected.to validate_presence_of(:friend_name) } 
  it { is_expected.to validate_presence_of(:friend_email) } 
  it { is_expected.to validate_presence_of(:message) } 
  it { is_expected.to validate_presence_of(:inviter_id) } 
  
  it "generates a random token when the inviation is created" do 
    invitation = Fabricate(:invitation)
    expect(invitation.token).to be_present
  end

end
