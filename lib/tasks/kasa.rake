namespace :kasa do

  desc "Fetches photos for a particular listing"
  task fetch_listing_photos: :environment do
    require 'rets_wrapper'
    rets = RetsWrapper.new
    rets.connect
    rets.experiment(ENV['LISTING_ID'],ENV['SYSID'])
  end

  desc "Connects to RETS api and download property listings"
  task fetch: :environment do
    require 'rets_wrapper'
    include ActionView::Helpers::DateHelper
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil

    started = Time.now
    listings = []
    rets = RetsWrapper.new
    rets.connect

    if ENV['LISTINGS'] == '1'
      puts "F95BA Purging"
      ActiveRecord::Base.connection.execute("TRUNCATE properties RESTART IDENTITY CASCADE")
      rets.counties.each do |county|
        listings += rets.download(county)
      end
      puts "F95BA Downloaded #{listings.size} listings in #{distance_of_time_in_words_to_now(started, {include_seconds: true})}"
    end

    if ENV['PHOTOS'] == '1'
      puts "F95BA Downloading photos"
      started = Time.now
      saved_photos_count = 0
      Property.all.order(id: :desc).each_with_index do |listing, serial_no|
        rets.get_photos(listing, serial_no,Property.all.size) #rescue puts "F95BA get_photos(#{listing['157']}, serial_no,listings.size)"
        saved_photos_count += 1
      end
      puts "F95BA Downloaded #{saved_photos_count}+ photos in #{distance_of_time_in_words_to_now(started, {include_seconds: true})}"
    end
    ActiveRecord::Base.logger = old_logger
  end


end
