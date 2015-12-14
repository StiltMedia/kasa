require 'rets'
require 'silence_warning'


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
  def save_to_s3(file_name)
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
    save_to_s3("#{listing['157']}.jpg") 
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
      select: '157,247,sysid',  # 247 Street Name
                                # 157 ListingID / ML#
      search_type:    'Property'
    }
    puts "#{results.size} listings"
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
                                       # Broward County
      limit: 1
    }
  end

end
