class Property < ActiveRecord::Base
  has_many :favorites
  has_many :adverts
  has_many :users, through: :favorites
  has_many :users, through: :adverts

  def is_favorite?(curr_user)
    Favorite.where(user_id: curr_user.id, property_id: self.id).size == 1
  end

  def sf
    "$#{self.price/self.area}/sf" rescue ""
  end

  def combined_address
    "#{address} #{city} #{state} #{zip}"
  end

  # accounts for deleted images
  def images_tot_available
    ret_val = images_tot
    ret_val = 0 if ! images_tot
    a = images_deleted
    a = "[]" if images_deleted.blank?
    a = JSON.parse(images_deleted) rescue []
    ret_val = images_tot - a.size
  end

  def is_photo_deleted?(index)
    deleteds = JSON.parse(images_deleted) rescue []
    deleteds.include?(index.to_s)
  end
end
