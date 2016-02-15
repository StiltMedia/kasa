class SeedSomeMoreUsers < ActiveRecord::Migration
  def up
    if ! User.find_by_email("hawkishtester+regular@gmail.com").present?
      User.create(
        email: "hawkishtester+regular@gmail.com",
        password: "password"
      )
    end
    names = [ "andrew", "betty", "cynthia", "david", "ethan" ]
    names.each do |name|
      if ! User.find_by_email("hawkishteste+#{name}@gmail.com").present?
        User.create(
          email: "hawkishtester+#{name}@gmail.com",
          password: "stilt123",
          seed: true
        )
      end
    end
  end
end
