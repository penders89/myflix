class Video < ActiveRecord::Base
  belongs_to :category
  
  has_many :reviews
  
  validates_presence_of :title, :description, :small_cover, :large_cover
  
  def self.search_by_title(search_string)
    return [] if search_string.blank?
    Video.where("title LIKE ?", "%#{search_string}%").order('created_at asc')
  end
end
