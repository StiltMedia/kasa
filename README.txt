
README


To start server locally, run

  rake assets:precompile; rails s -p 3001 # or
  PORT=3000 foreman start #assuming you have foreman installed

To download listings, run

  bundle exec rake kasa:fetch LISTINGS=1 PHOTOS=0

To download photos, do

  bundle exec rake kasa:fetch LISTINGS=0 PHOTOS=1

Preconfigured users are

  guigo@stiltmedia.com password: stilt123
  info@stiltmedia.com password: stilt123
  john@stiltmedia.com password: stilt123
  jane@stiltmedia.com password: stilt123
  The first one is an admin.
  

A dump of the database will be kept at db/latest.dump

To dump heroku db to a local file

  heroku pg:backups capture --app kasa-whatever
  curl -o db/latest.dump `heroku pg:backups public-url --app kasa-whatever`

To import dump in to local db

  pg_restore --verbose --clean --no-acl --no-owner -h localhost -d kasa_dev db/latest.dump
