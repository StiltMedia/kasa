
def foo
  "baa"
end

def files_in_bucket(region,username,password,bucketname)
  require 'aws-sdk'
    @s3 = Aws::S3::Resource.new(region:region,
      credentials: Aws::Credentials.new(username, password))
    @s3.bucket(bucketname).objects.collect(&:key)
end
