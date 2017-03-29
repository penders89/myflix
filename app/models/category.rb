class Category < ActiveRecord::Base
  has_many :videos, -> { order('title desc') }
  
  validates_presence_of :name
end