#ゲストデータ+++++++++++++++++++++++++++++++++++++++++++++++
guest = User.create!( id: Rails.application.credentials.guest[:id],
                      name:  "ゲスト",
                      email: "guest@example.com",
                      password:              "811278566289988038",
                      password_confirmation: "811278566289988038",
                      guest: true)
Contest.create!(name:  "ゲストが作成したコンテスト",
                user_id: Rails.application.credentials.guest[:id])


#ダミーデータ++++++++++++++++++++++++++++++++++++++++
29.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@example.com"
  password = "password#{n+1}"
  user = User.create!(name:  name,
                      email: email,
                      password:              password,
                      password_confirmation: password)
  rand(5).times do |n|
    name  = Faker::Movie.title
    Contest.create!(name:  name,
                    user_id: user.id)
  end
end
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
