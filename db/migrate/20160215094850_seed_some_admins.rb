class SeedSomeAdmins < ActiveRecord::Migration
  def up
    User.find_by_email("guigo@stiltmedia.com").update_attribute("admin",true)
  end
end
