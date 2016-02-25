class Advert < ActiveRecord::Base
  belongs_to :user
  belongs_to :property
  has_many :open_house_times
end
