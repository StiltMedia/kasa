class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :favorites
  has_many :properties, through: :favorites
  has_many :adverts
  has_many :properties, through: :adverts
  has_many :feeds

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

  # given a time in integer format, returns hits that
  # happened on that day &&
  # was for a property listed by this user
  def hits_for_day(timestamp)
    properties = Advert.where(user_id: self.id).pluck(:property_id)
    beg_time = Time.zone.at(timestamp).beginning_of_day
    end_time = Time.zone.at(timestamp).end_of_day
    Hit.where("property_id IN (?)", properties).where(created_at: beg_time..end_time).all
  end

  # participatng tickets  
  def tickets
    #memos = Memo.where("mfrom = ? or mto = ?", self.id, self.id)
    #ticket_ids = memos.pluck(:ticket_id)
    #Ticket.where("id IN (?)",ticket_ids).all
    Ticket.where(tuser: self.id)
  end

  def open_tickets
    self.tickets.select { |x| x.state == "open" }
  end

  def open_awaiting_tickets
    self.tickets.select { |x| (x.state == "open" && x.last_sayer_id != self.id) rescue nil }
  end


  def self.open_tickets_admin
    Ticket.where(state: "open").all
  end

  def self.open_awaiting_tickets_admin
    Ticket.where(state: "open").all.select do |ticket|
      (ticket.last_sayer.admin != true) rescue false
    end
  end

  def last_advert
    Advert.where(user_id: id).order(id: :asc).last
  end

  def has_unfinished_advert_creation
     last_advert && last_advert.completed != true
  end

  def nick
    self.email.split('@')[0].titleize
  end

  # given a negotiation, returns "s" if user is a seller in that negotiation,
  # "b" if buyer
  # "z" if neither
  def neg_role(n)
    ret_val = "z"
    ret_val = "b" if n.buyer_id == self.id
    ret_val = "s" if n.seller_id == self.id
  end
end
