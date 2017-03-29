require 'spec_helper'

describe Video do 
  it { is_expected.to validate_presence_of(:title) } 
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to belong_to(:category) }
  
  
end