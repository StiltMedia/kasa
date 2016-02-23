class SeedSomeMemos < ActiveRecord::Migration
  def up
    User.all.each do |user|
      rand(1..2).times do
        Ticket.create(
          subject: Faker::Hipster.sentence,
          state: ["open","closed"].sample(1)[0]
        )
      end
    end
    
    Ticket.all.each do |ticket|
      participants = [ 'kasa@kasa-staging.herokuapp.com', User.all.sample(1)[0].email ]
      rand(1..10).times do
        pair = participants.shuffle
        Memo.create(
          body: Faker::Hipster.paragraph(rand(1..10)),
          ticket_id: ticket.id,
          from: pair.first,
          to: pair.last
        )
      end
    end
    
  end
end
