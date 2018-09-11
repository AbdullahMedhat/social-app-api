(0..5).each do |con|
  u = User.create!(
    email: "#{con}@a.com",
    password: "12345678",
    username: "user#{con}"
  )

  (0..3).each do |con1|
    l = u.lists.create!(
      title: "list#{con1}"
    )

    (0..3).each do |con2|
      c = l.cards.create!(
        title: "card#{con2}",
        description: "card#{con2} description",
        user: u
      )

      (0..(con2 + 1)).each do |con3|
        c.comments.create!(
          content: "Comment for card#{c.id} #{con3}",
          user: u
        )
      end
    end
  end
end
