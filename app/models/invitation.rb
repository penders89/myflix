class Invitation < ActiveRecord::Base 
  validates_presence_of :friend_name, :friend_email, :message, :inviter_id
  
  belongs_to :inviter,  class_name: "User"
  
  
  before_create :generate_token 
  
  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end

  
end