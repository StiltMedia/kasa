class SeedSomeMoreUsers < ActiveRecord::Migration
  def up
    if ! User.find_by_email("hawkishtester+regular@gmail.com").present?
      User.create(
        email: "hawkishtester+regular@gmail.com",
        password: "password"
      )
    end
  end
end
