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
  
  
end