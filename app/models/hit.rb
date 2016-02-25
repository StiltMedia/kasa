class Hit < ActiveRecord::Base

  def self.last_30_days(user)
    ret_val = []
    30.times do |i|
      if ! user
        ret_val.push( Hit.where(htime: (Time.now()-(i+1).days).end_of_day..(Time.now()-i.days).end_of_day).size   )
      else
        ret_val.push( Hit.where(user_id: user.id, htime: (Time.now()-(i+1).days).end_of_day..(Time.now()-i.days).end_of_day).size   )
      end
    end
    #(1..30).each do |i|
    #  range_start = (Time.now() - i.days).midnight()
    #  range_end = (Time.now() - i.days + 1.day).midnight()
    #  ret_val.push( Hit.where(htime: range_start..range_end).size   )
    #end
    ret_val
  end
end
