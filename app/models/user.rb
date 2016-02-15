class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :favorites
  has_many :properties, through: :favorites
  has_many :adverts
  has_many :properties, through: :adverts

  def offers
    all_offers = Offer.all
    return all_offers.select { |offer|
      Advert.where(user_id: self.id, property_id: offer.property_id).all.size > 0
    }
  end

  def pending_offers
    all_offers = Offer.all
    offers =  all_offers.select { |offer|
      Advert.where(user_id: self.id, property_id: offer.property_id).all.size > 0
    }
    offers.select { |x| x.reviewed == nil || x.reviewed == false }
  end

  def total_views
    properties = self.adverts.pluck(:property_id)
    hits = Hit.all.select { |h| properties.include? h.property_id }
    hits.size
  end
end
