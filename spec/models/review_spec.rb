require 'spec_helper'

describe Review do 
  it { is_expected.to belong_to(:user) } 
  it { is_expected.to belong_to(:video) }
  
end