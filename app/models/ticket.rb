class Ticket < ActiveRecord::Base

  def last_sayer
    User.find(Memo.where(ticket_id: self.id).all.order(created_at: :desc).first.mfrom) rescue User.none
  end

  def last_sayer_id
    User.find(Memo.where(ticket_id: self.id).all.order(created_at: :desc).first.mfrom).id rescue nil
  end
end
