require 'spec_helper'

describe Review do 
  it { is_expected.to belong_to(:user) } 
  it { is_expected.to belong_to(:video) }
  it { is_expected.to validate_numericality_of(:rating)
    .only_integer.is_less_than_or_equal_to(5).is_greater_than_or_equal_to(1)}
  
end