class User < ActiveRecord::Base
  has_secure_password validations: false
  
  has_many :reviews
  has_many :queue_items, -> { order('ranking ASC') }
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id
  
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: [:create], length: { minimum: 8 }

  before_create :generate_token
 
  def normalise_queue_item_rankings
    queue_items.each_with_index do | queue_item, index|
      queue_item.update_attributes(ranking: index + 1)
    end
  end
  
  def follows?(another_user)
    following_relationships.map(&:leader).include?(another_user)
  end
  
  def can_follow?(another_user) 
    !(self.follows?(another_user) || self == another_user)
  end
  
  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end