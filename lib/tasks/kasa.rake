namespace :kasa do
  desc "Connects to RETS api and download property listings"
  task fetch: :environment do
    include ActionView::Helpers::DateHelper
    started = Time.now
    listings = []
    require 'rets_wrapper'
    rets = RetsWrapper.new
    rets.connect
    rets.counties.each do |county|
      listings += rets.download(county)
    end
    puts "Downloaded #{listings.size} listings in #{distance_of_time_in_words_to_now(started, {include_seconds: true})}"
    next if ENV['PHOTOS'] != '1'  #skip photos if photos not reqested
    puts "Downloading photos"
    started = Time.now
    saved_photos_count = 0
    listings.each_with_index do |listing, serial_no|
      rets.get_photos(listing, serial_no,listings.size)
      saved_photos_count += 1
    end
    puts "Downloaded #{saved_photos_count} photos in #{distance_of_time_in_words_to_now(started, {include_seconds: true})}"
  end


end
