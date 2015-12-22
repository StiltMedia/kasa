require 'rets'
require 'silence_warning'

# Key RETS field codes
#         pg          type
# 157     listing_id  string
# 881     address     string
# 10      zip         string
# 922     City        string
# 924     State       string
# 137     price       number
# 261     area        number
# 246     status      string
# 80      date        timestamp
# 61      county      string
# 25      beds        integer
# 1424    baths       integer
# 102     garage      integer
# 214     remarks     text
# 314     built       string
# 96      floor       string
# 1       type        string
# syscode syscode     string

class RetsWrapper  
  COUNTIES = [ 'GLADES', 'HENDRY',
               'INDNRIV', 'MARTIN', 'OKEECHB',
               'PALMBCH', 'STLUCIE', 'BROWARD', 'DADE', 'OTHER' ]
  S3_BUCKET = 'kasa-staging'
  S3_LOGIN = 'AKIAI5R5DFMV3PYHNBDQ'
  S3_PASSWORD = 'NKUknIpVGfEr+ZqlJfTytH5eCpjcuVaVY87PY/Sp'

  def initialize
    @client = nil
    @s3 = nil
  end

  def connect
    puts "F95BA Connecting to RETS api"
    @client = Rets::Client.new({
      login_url: 'http://sef.rets.interealty.com/Login.asmx/Login',
      username: 'guilRWSmo',
      password: 'gt5160ms',
      version: 'RETS/1.5',
      ua_password: "123456",
      agent: "RETS-Connector/1.2"
    })
   verify_connection()
  end

  def counties
    COUNTIES
  end

  def connect_to_s3
    require 'aws-sdk'
    @s3 = Aws::S3::Resource.new(region:'us-west-1',
      credentials: Aws::Credentials.new(S3_LOGIN, S3_PASSWORD))
    @bucket_files = @s3.bucket('kasa-staging').objects.collect(&:key)
  end

  # saves an image to s3
  def save_to_s3(file_name, listing_id)
    connect_to_s3() if ! @s3
    obj = @s3.bucket(S3_BUCKET).object(file_name)
    obj.upload_file('tmp/tmp.jpg')
  end

  # checks whether we already have the image for a listing
  def image_exists?(listing_id, ndx)
    result = nil
    connect_to_s3() if ! @s3
    result = @bucket_files.select { |file_name| file_name =~ /#{listing_id}_#{ndx}/ }.present?
    result
  end

  def get_photos(listing, serial_no,total)
    #if image_exists?(listing['157'])
    #  puts " F95BA #{serial_no+1}/#{total} #{listing['157']}_0.jpg exists, skipping"
    #  return
    #end
    imgs = (@client.objects '*', { resource: 'Property', object_type: 'Photo', resource_id: listing['sysid']+':0' }) rescue Array.new
    imgs.reject! { |img| img.to_s[0..200] =~ /Object not available/ }
    images_tot = imgs.size
    images_tot = 5 if imgs.size >= 5
    listing.update_attribute(:images_tot, images_tot)

    imgs[0..3].each_with_index do |img, ndx|
      if image_exists?(listing['listing_id'],ndx)
        puts " F95BA #{(serial_no+1).to_s.rjust(4,' ')}/#{total} Listing ID #{listing['listing_id'].ljust(10," ")}, #{imgs.size.to_s.rjust(2,"0")} photos. skipping \##{ndx+1}."        
      else
        File.open("tmp/tmp.jpg", 'wb') { |file| file.write imgs[ndx].body }
        file_name = "#{listing['listing_id']}_#{ndx}.jpg"
        save_to_s3(file_name,listing['listing_id'])
        puts " F95BA #{(serial_no+1).to_s.rjust(4,' ')}/#{total} Listing ID #{listing['listing_id'].ljust(10," ")}, #{imgs.size.to_s.rjust(2,"0")} photos. saved \##{ndx+1}."
      end
    end

    return imgs.size
  end

  # downloads listings, sans photos
  def download(county)
    puts " F95BA #{county}"
    results = @client.find :all, {
      class:          '1', # 1 Residential
      query:          "(246=|A),(61=|#{county})", #246 ListingStatus
                                                  #A ActiveAvailable
                                                  #61 County
      select: '157,881,10,922,924,137,261,246,80,61,25,1424,102,214,314,96,1,sysid', 
      search_type:    'Property'
    }
    puts "F95BA #{results.size} listings"
    puts "F95BA saving"
    pg_save(results)
    results
  end


  def experiment(listing_id, sysid)
    puts __method__.to_s + " "+ listing_id
    imgs = (@client.objects '*', { resource: 'Property', object_type: 'Photo', resource_id: sysid+':0' }) rescue Array.new
  end

  private

  # verify rets connection by issuing a simple request
  # to find 1 active listing in Broward County
  def verify_connection
    @client.find :first, {
      search_type: 'Property',
      class: '1', # 1 Residential
      query: '(246=|A),(61=|BROWARD)', # 246 ListingStatus
                                       # A Active-Available
                                       # 61 County
      limit: 1
    }
  end

  def pg_save(listings)
    listings.each do |l|
      puts "F95BA .NOBR"
      Property.create(
        listing_id: l['157'],
        address: l['881'],
        zip: l['10'],
        city: l['922'],
        state: l['924'],
        price: l['137'],
        area: l['261'],
        date: l['80'],
        beds: l['25'],
        baths: l['1424'],
        garage: l['102'],
        county: l['61'],
        remarks: l['214'],
        built: l['314'],
        floor: l['96'],
        ptype: l['1'],
        sysid: l['sysid'])
      end
    puts "F95BA saved"
  end
end
