#ユーザ+++++++++++++++++++++++++++++++++++++++++++++++++++++
#ゲストデータ+++++++++++++++++++++++++++++++++++++++++++++++
User.create!( name:  "ゲスト",
              email: "guest@example.com",
              password:              "811278566289988038",
              password_confirmation: "811278566289988038",
              guest: true)
#ユーザのダミーデータ++++++++++++++++++++++++++++++++++++++++
29.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@example.com"
  password = "password#{n+1}"
  User.create!( name:  name,
                email: email,
                password:              password,
                password_confirmation: password)
end
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#コンテストダミーデータ+++++++++++++++++++++++++++++++++++++++
Contest.create!(name:  "ゲストが作成したコンテスト",
                user_id: 1)
29.times do |n|
  name  = Faker::Movie.title
  Contest.create!( name:  name,
                user_id: rand(2..30))
end
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
