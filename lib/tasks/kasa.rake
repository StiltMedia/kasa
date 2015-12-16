namespace :kasa do
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
    puts "F95BA Purging"
    ActiveRecord::Base.connection.execute("TRUNCATE properties RESTART IDENTITY")
    rets.counties.each do |county|
      listings += rets.download(county)
    end
    puts "F95BA Downloaded #{listings.size} listings in #{distance_of_time_in_words_to_now(started, {include_seconds: true})}"
    next if ENV['PHOTOS'] != '1'  #skip photos if photos not reqested
    puts "F95BA Downloading photos"
    started = Time.now
    saved_photos_count = 0
    listings.each_with_index do |listing, serial_no|
      rets.get_photos(listing, serial_no,listings.size) rescue puts "F95BA get_photos(#{listing['157']}, serial_no,listings.size)"
      saved_photos_count += 1
    end
    puts "F95BA Downloaded #{saved_photos_count} photos in #{distance_of_time_in_words_to_now(started, {include_seconds: true})}"
    ActiveRecord::Base.logger = old_logger
  end


end