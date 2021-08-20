#ゲストデータ+++++++++++++++++++++++++++++++++++++++++++++++
guest = User.create!( id: Rails.application.credentials.guest[:id],
                      name:  "ゲスト",
                      email: "guest@example.com",
                      password:              Rails.application.credentials.guest[:password],
                      password_confirmation: Rails.application.credentials.guest[:password],
                      guest: true)
# contest = Contest.create!(name:  "ゲストが作成したコンテスト",
#                           user_id: Rails.application.credentials.guest[:id])
# photo = Photo.create!(name:       'ゲストの写真',
#                       user_id:    guest.id,
#                       contest_id: contest.id)


# #ダミーデータ++++++++++++++++++++++++++++++++++++++++
# 40.times do |n|
#   #ユーザ
#   name  = Faker::Name.name
#   email = "example-#{n+1}@example.com"
#   password = "password#{n+1}"
#   user = User.create!(name:                  name,
#                       email:                 email,
#                       password:              password,
#                       password_confirmation: password)
#   #コンテスト
#   rand(5).times do |n|
#     name  = Faker::Movie.title
#     contest = Contest.create!(name:    name,
#                               user_id: user.id)
#     #写真
#     if rand(5) == 0 || 1 || 2
#       name = name = Faker::File.file_name
#       photo = Photo.create!(name:       name,
#                             user_id:    user.id,
#                             contest_id: contest.id)
#     end
#   end
# end
# #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
