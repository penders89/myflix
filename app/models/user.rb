class User < ActiveRecord::Base
  has_secure_password validations: false
  
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: [:create], length: { minimum: 8 }

end