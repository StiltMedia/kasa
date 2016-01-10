
def files_in_bucket(region,username,password,bucketname)
  require 'aws-sdk'
    @s3 = Aws::S3::Resource.new(region:region,
      credentials: Aws::Credentials.new(username, password))
    @s3.bucket(bucketname).objects.collect(&:key)
end

def photos_available(listing_id)
  require 'rets'
  @client = Rets::Client.new({
    login_url: 'http://sef.rets.interealty.com/Login.asmx/Login',
    username: 'guilRWSmo',
    password: 'gt5160ms',
    version: 'RETS/1.5',
    ua_password: "123456",
    agent: "RETS-Connector/1.2"
  })
  sysid = Property.find_by_listing_id(listing_id).sysid
  byebug
  (@client.objects '99', { resource: 'Property', object_type: 'Photo', resource_id: sysid+':0' }).size
end
