class Property < ActiveRecord::Base
  has_many :favorites
  has_many :users, through: :favorites

  def is_favorite?(curr_user)
    Favorite.where(user_id: curr_user.id, property_id: self.id).size == 1
  end
end
