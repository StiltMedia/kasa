
README


To start server locally, run

  PORT=3000 foreman start #assuming you have foreman installed

To download listings, run

  bundle exec rake kasa:fetch LISTINGS=1 PHOTOS=0

To download photos, do

  bundle exec rake kasa:fetch LISTINGS=0 PHOTOS=1

Preconfigured users are

  guigo@stiltmedia.com password: stilt123
  info@stiltmedia.com password: stilt123
  The first one is an admin.

