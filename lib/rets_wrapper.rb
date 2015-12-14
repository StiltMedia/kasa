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
# syscode syscode     string

class RetsWrapper  
  COUNTIES = [ 'BROWARD' , 'DADE', 'GLADES', 'HENDRY',
               'INDNRIV', 'MARTIN', 'OKEECHB', 'OTHER',
               'PALMBCH', 'STLUCIE' ]
  S3_BUCKET = 'kasa-staging'
  S3_LOGIN = 'AKIAI5R5DFMV3PYHNBDQ'
  S3_PASSWORD = 'NKUknIpVGfEr+ZqlJfTytH5eCpjcuVaVY87PY/Sp'

  def initialize
    @client = nil
    @s3 = nil
  end

  def connect
    puts "Connecting to RETS api"
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
  end

  # saves an image to s3
  def save_to_s3(file_name, listing_id)
    connect_to_s3() if ! @s3
    obj = @s3.bucket(S3_BUCKET).object(file_name)
    obj.upload_file('tmp/tmp.jpg')
  end

  def get_photos(listing, serial_no,total)
    imgs = @client.objects '*', {
      resource: 'Property',
      object_type: 'Photo',
      resource_id: listing['sysid']+':0'
    }
    File.open("tmp/tmp.jpg", 'wb') { |file| file.write imgs[0].body }
    file_name = "#{listing['157']}_0.jpg"
    save_to_s3(file_name,listing['157'])
    puts " #{serial_no+1}/#{total} Listing ID #{listing['157']}, #{imgs.size} photos. 1 saved."
  end

  # downloads listings, sans photos
  def download(county)
    print " #{county}: "
    results = @client.find :all, {
      class:          '1', # 1 Residential
      query:          "(246=|A),(61=|#{county})", #246 ListingStatus
                                                  #A ActiveAvailable
                                                  #61 County
      select: '157,881,10,922,924,137,261,246,80,61,25,1424,102,sysid', 
      search_type:    'Property'
    }
    print "#{results.size} listings "
    pg_save(results)
    results
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
        sysid: l['sysid'])
      end
    puts "saved"
  end
end
