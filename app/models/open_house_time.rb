class OpenHouseTime < ActiveRecord::Base
  belongs_to :advert

  def self.times_collection
    %w( 6am 7am 8am 9am 10am 11am 12noon 1pm 2pm 3pm 4pm 5pm 6pm 7pm 8pm 9pm)
  end

end
