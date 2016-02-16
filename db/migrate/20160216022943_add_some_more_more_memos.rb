class AddSomeMoreMoreMemos < ActiveRecord::Migration
  def change
    if ! User.find_by_email("postmaster@kasa-staging.herokuapp.com").present?
      User.create( seed: true, email: "postmaster@kasa-staging.herokuapp.com", password: "stilt123")
    end
    
    Memo.destroy_all
    Ticket.destroy_all
    User.all.each do |user|
      rand(1..2).times do
        Ticket.create(
          subject: Faker::Hipster.sentence,
          state: ["open","closed"].sample(1)[0],
          tuser: user.id
        )
      end
    end

    Ticket.all.each do |ticket|
      rand(1..10).times do
        Memo.create(
          body: Faker::Hipster.paragraph(rand(1..10)),
          ticket_id: ticket.id,
          mfrom: [  User.find_by_email('postmaster@kasa-staging.herokuapp.com').id, ticket.tuser   ].sample(1)[0]
        )
      end
    end

  end
end
