class Ticket < ActiveRecord::Base

  def last_sayer
    User.find(Memo.where(ticket_id: self.id).all.order(created_at: :desc).first.mfrom)
  end

end
