class Invitation < ActiveRecord::Base 
  include Tokenable
  
  validates_presence_of :friend_name, :friend_email, :message, :inviter_id
  
  belongs_to :inviter,  class_name: "User"
  
  
  
end