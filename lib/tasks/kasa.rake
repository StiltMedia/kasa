namespace :kasa do

  desc "Untitled"
  task untitled: :environment do
    puts "Abc"
    Property.all.each_with_index do |p,i|
     puts "#{i} #{p.id} #{p.listing_id} #{p.address[0..6]}"
    end
  end

  desc "Quick sync job"
  task synch_it: :environment do
    puts "synch_it"
    require "sam.rb"
    b1 = files_in_bucket('us-west-1','AKIAI5R5DFMV3PYHNBDQ','NKUknIpVGfEr+ZqlJfTytH5eCpjcuVaVY87PY/Sp','kasa-staging')
    b2 = files_in_bucket('us-west-2','AKIAJ6P4PCOUQL5GW52Q','67/kSQQuGN/cgvtmREDpBu8jYsLTeA0nuP3LI/tW','kasa-staging-02')
    b3 = b1.select { |x| !(b2.include? x) }
    tot = b3.size
    @s3_new = Aws::S3::Resource.new(region:'us-west-2',
      credentials: Aws::Credentials.new('AKIAJ6P4PCOUQL5GW52Q', '67/kSQQuGN/cgvtmREDpBu8jYsLTeA0nuP3LI/tW'))
    ENV['AWS_REGION'] = 'us-west-1'
    s3 = Aws::S3::Client.new(credentials: Aws::Credentials.new('AKIAI5R5DFMV3PYHNBDQ', 'NKUknIpVGfEr+ZqlJfTytH5eCpjcuVaVY87PY/Sp'))
    b3.each_with_index do |x, ndx|
      puts "#{ndx}/#{tot} #{x}"



      File.open('/tmp/filename.jpg', 'wb') do |file|
        reap = s3.get_object({ bucket:'kasa-staging', key:x }, target: file)
      end

      @s3_new.bucket('kasa-staging-02').object(x).upload_file('/tmp/filename.jpg')
    end        

  end

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
      Property.all.order(last_trans_date: :desc)[3325..-1].each_with_index do |listing, serial_no|
        rets.get_photos(listing, serial_no,Property.all.size) #rescue puts "F95BA get_photos(#{listing['157']}, serial_no,listings.size)"
        saved_photos_count += 1
      end
      puts "F95BA Downloaded #{saved_photos_count}+ photos in #{distance_of_time_in_words_to_now(started, {include_seconds: true})}"
    end
    ActiveRecord::Base.logger = old_logger
  end


end
