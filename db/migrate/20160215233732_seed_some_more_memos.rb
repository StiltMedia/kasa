class SeedSomeMoreMemos < ActiveRecord::Migration
  def change
    if ! User.find_by_email("kasa@kasa-staging.herokuapp.com").present?
      User.create( seed: true, email: "kasa@kasa-staging.herokuapp.com", password: "stilt123")
    end
    
    Memo.destroy_all
    Ticket.destroy_all
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
          mfrom: User.find_by_email(pair.first).id,
          mto: User.find_by_email(pair.last).id
        )
      end
    end
  end
end
