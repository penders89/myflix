class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  
  validates_presence_of :user
  validates_presence_of :video
  validates_presence_of :ranking
  
end