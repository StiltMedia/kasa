class SeedSomeFeeds < ActiveRecord::Migration
  def up
    rand(2..100).times do
      Feed.create(
        message: Faker::Hipster.sentence,
        user_id: [ nil, User.all.sample(1)[0].id].sample(1)[0]
      )
    end
  end
end
