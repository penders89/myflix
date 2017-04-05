require 'spec_helper'

describe Invitation do 
  it { is_expected.to validate_presence_of(:friend_name) } 
  it { is_expected.to validate_presence_of(:friend_email) } 
  it { is_expected.to validate_presence_of(:message) } 
  it { is_expected.to validate_presence_of(:inviter_id) } 
  
  it_behaves_like "tokenable" do 
    let(:object) { Fabricate(:invitation) }
  end

end
