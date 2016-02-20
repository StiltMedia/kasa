class Ticket < ActiveRecord::Base

  def last_sayer
    User.find(Memo.where(ticket_id: self.id).all.order(created_at: :desc).first.mfrom) rescue User.none
  end

  def awaiting_reply(user)
    self.state != "closed" && user.id != self.last_sayer.id
  end
end
