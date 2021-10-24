#テストデータ++++++++++++++++++++++++++++++++++++++++++
#Tom
user_Tom = User.create!(
  name: 'Tome',
  user_id: 'tom_user',
  password: 'tomfoobar',
  password_confirmation: 'tomfoobar'
)

user_Ken = User.create!(
  name: 'Ken',
  user_id: 'ken_user',
  password: 'kenfoobar',
  password_confirmation: 'kenfoobar'
)

now = Time.current
#0:募集前、1:募集中、2:募集後投票前、3:投票中、4:投票後

#募集前+++++++++++++++++++++++++++++++++++++++++++++++
#Tom作成
contest_Tom_0 = Contest.new(
  name: 'コンテスト_Tom_募集前',
  user_id: user_Tom.id,
  description: 'コンテスト_Tom_募集前。の説明',
  entry_start_at: now.since(10.days),
  entry_end_at: now.since(10.days),
  vote_start_at: now.since(10.days),
  vote_end_at: now.since(10.days),
  visible_range_entry: 0,
  visible_range_vote: 0,
  visible_range_show: 0,
  visible_range_result: 0,
  voting_points: 3,
  num_of_views_in_result: 3,
  visible_setting_for_user_name: 0,
  limited_url_entry: SecureRandom.alphanumeric(16),
  limited_url_vote: SecureRandom.alphanumeric(16),
  limited_url_show: SecureRandom.alphanumeric(16),
  limited_url_result: SecureRandom.alphanumeric(16),
).save!(validate: false)
#Ken作成
contest_Tom_0 = Contest.new(
  name: 'コンテスト_Ken_募集前',
  user_id: user_Ken.id,
  description: 'コンテスト_Ken_募集前。の説明',
  entry_start_at: now.since(10.days),
  entry_end_at: now.since(10.days),
  vote_start_at: now.since(10.days),
  vote_end_at: now.since(10.days),
  visible_range_entry: 0,
  visible_range_vote: 0,
  visible_range_show: 0,
  visible_range_result: 0,
  voting_points: 3,
  num_of_views_in_result: 3,
  visible_setting_for_user_name: 0,
  limited_url_entry: SecureRandom.alphanumeric(16),
  limited_url_vote: SecureRandom.alphanumeric(16),
  limited_url_show: SecureRandom.alphanumeric(16),
  limited_url_result: SecureRandom.alphanumeric(16),
)
contest_Tom_0.save!(validate: false)




#募集中+++++++++++++++++++++++++++++++++++++++++++++++
#Tom作成、応募者0人
contest_Tom_1 = Contest.new(
  name: 'コンテスト_Tom_募集中_応募0',
  user_id: user_Tom.id,
  description: 'コンテスト_Tom_募集中。の説明',
  entry_start_at: now.ago(10.days),
  entry_end_at: now.since(10.days),
  vote_start_at: now.since(10.days),
  vote_end_at: now.since(10.days),
  visible_range_entry: 0,
  visible_range_vote: 0,
  visible_range_show: 0,
  visible_range_result: 0,
  voting_points: 3,
  num_of_views_in_result: 3,
  visible_setting_for_user_name: 0,
  limited_url_entry: SecureRandom.alphanumeric(16),
  limited_url_vote: SecureRandom.alphanumeric(16),
  limited_url_show: SecureRandom.alphanumeric(16),
  limited_url_result: SecureRandom.alphanumeric(16),
)
contest_Tom_1.save!(validate: false)

#Tom作成、応募者10人
contest_Tom_1_1 = Contest.new(
  name: 'コンテスト_Tom_募集中_応募10',
  user_id: user_Tom.id,
  description: 'コンテスト_Tom_募集中。の説明',
  entry_start_at: now.ago(10.days),
  entry_end_at: now.since(10.days),
  vote_start_at: now.since(10.days),
  vote_end_at: now.since(10.days),
  visible_range_entry: 0,
  visible_range_vote: 0,
  visible_range_show: 0,
  visible_range_result: 0,
  voting_points: 3,
  num_of_views_in_result: 3,
  visible_setting_for_user_name: 0,
  limited_url_entry: SecureRandom.alphanumeric(16),
  limited_url_vote: SecureRandom.alphanumeric(16),
  limited_url_show: SecureRandom.alphanumeric(16),
  limited_url_result: SecureRandom.alphanumeric(16),
)
contest_Tom_1_1.save!(validate: false)

contest_Ken_1 = Contest.new(
  name: 'コンテスト_Ken_募集中_応募0',
  user_id: user_Ken.id,
  description: 'コンテスト_Ken_募集中。の説明',
  entry_start_at: now.ago(10.days),
  entry_end_at: now.since(10.days),
  vote_start_at: now.since(10.days),
  vote_end_at: now.since(10.days),
  visible_range_entry: 0,
  visible_range_vote: 0,
  visible_range_show: 0,
  visible_range_result: 0,
  voting_points: 3,
  num_of_views_in_result: 3,
  visible_setting_for_user_name: 0,
  limited_url_entry: SecureRandom.alphanumeric(16),
  limited_url_vote: SecureRandom.alphanumeric(16),
  limited_url_show: SecureRandom.alphanumeric(16),
  limited_url_result: SecureRandom.alphanumeric(16),
)
contest_Ken_1.save!(validate: false)

#Tom作成、応募者10人
contest_Ken_1_1 = Contest.new(
  name: 'コンテスト_Ken_募集中_応募10',
  user_id: user_Ken.id,
  description: 'コンテスト_Ken_募集中。の説明',
  entry_start_at: now.ago(10.days),
  entry_end_at: now.since(10.days),
  vote_start_at: now.since(10.days),
  vote_end_at: now.since(10.days),
  visible_range_entry: 0,
  visible_range_vote: 0,
  visible_range_show: 0,
  visible_range_result: 0,
  voting_points: 3,
  num_of_views_in_result: 3,
  visible_setting_for_user_name: 0,
  limited_url_entry: SecureRandom.alphanumeric(16),
  limited_url_vote: SecureRandom.alphanumeric(16),
  limited_url_show: SecureRandom.alphanumeric(16),
  limited_url_result: SecureRandom.alphanumeric(16),
)
contest_Ken_1_1.save!(validate: false)



#募集後投票前+++++++++++++++++++++++++++++++++++++++++++++++++++++++
#Tom作成、応募0人
contest_Tom_2 = Contest.new(
  name: 'コンテスト_Tom_募集後投票前_応募0',
  user_id: user_Tom.id,
  description: 'コンテスト_Tom_募集後投票前。の説明',
  entry_start_at: now.ago(10.days),
  entry_end_at: now.ago(10.days),
  vote_start_at: now.since(10.days),
  vote_end_at: now.since(10.days),
  visible_range_entry: 0,
  visible_range_vote: 0,
  visible_range_show: 0,
  visible_range_result: 0,
  voting_points: 3,
  num_of_views_in_result: 3,
  visible_setting_for_user_name: 0,
  limited_url_entry: SecureRandom.alphanumeric(16),
  limited_url_vote: SecureRandom.alphanumeric(16),
  limited_url_show: SecureRandom.alphanumeric(16),
  limited_url_result: SecureRandom.alphanumeric(16),
)
contest_Tom_2.save!(validate: false)

#Tom作成、応募10人
contest_Tom_2_1 = Contest.new(
  name: 'コンテスト_Tom_募集後投票前_応募10',
  user_id: user_Tom.id,
  description: 'コンテスト_Tom_募集後投票前。の説明',
  entry_start_at: now.ago(10.days),
  entry_end_at: now.ago(10.days),
  vote_start_at: now.since(10.days),
  vote_end_at: now.since(10.days),
  visible_range_entry: 0,
  visible_range_vote: 0,
  visible_range_show: 0,
  visible_range_result: 0,
  voting_points: 3,
  num_of_views_in_result: 3,
  visible_setting_for_user_name: 0,
  limited_url_entry: SecureRandom.alphanumeric(16),
  limited_url_vote: SecureRandom.alphanumeric(16),
  limited_url_show: SecureRandom.alphanumeric(16),
  limited_url_result: SecureRandom.alphanumeric(16),
)
contest_Tom_2_1.save!(validate: false)

#Ken作成、応募0人
contest_Ken_2 = Contest.new(
  name: 'コンテスト_Ken_募集後投票前_応募0',
  user_id: user_Ken.id,
  description: 'コンテスト_Ken_募集後投票前。の説明',
  entry_start_at: now.ago(10.days),
  entry_end_at: now.ago(10.days),
  vote_start_at: now.since(10.days),
  vote_end_at: now.since(10.days),
  visible_range_entry: 0,
  visible_range_vote: 0,
  visible_range_show: 0,
  visible_range_result: 0,
  voting_points: 3,
  num_of_views_in_result: 3,
  visible_setting_for_user_name: 0,
  limited_url_entry: SecureRandom.alphanumeric(16),
  limited_url_vote: SecureRandom.alphanumeric(16),
  limited_url_show: SecureRandom.alphanumeric(16),
  limited_url_result: SecureRandom.alphanumeric(16),
)
contest_Ken_2.save!(validate: false)

#Tom作成、応募10人
contest_Ken_2_1 = Contest.new(
  name: 'コンテスト_Ken_募集後投票前_応募10',
  user_id: user_Ken.id,
  description: 'コンテスト_Ken_募集後投票前。の説明',
  entry_start_at: now.ago(10.days),
  entry_end_at: now.ago(10.days),
  vote_start_at: now.since(10.days),
  vote_end_at: now.since(10.days),
  visible_range_entry: 0,
  visible_range_vote: 0,
  visible_range_show: 0,
  visible_range_result: 0,
  voting_points: 3,
  num_of_views_in_result: 3,
  visible_setting_for_user_name: 0,
  limited_url_entry: SecureRandom.alphanumeric(16),
  limited_url_vote: SecureRandom.alphanumeric(16),
  limited_url_show: SecureRandom.alphanumeric(16),
  limited_url_result: SecureRandom.alphanumeric(16),
)
contest_Ken_2_1.save!(validate: false)




#投票中++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#Tom作成、応募0人
contest_Tom_3 = Contest.new(
  name: 'コンテスト_Tom_投票中応募0',
  user_id: user_Tom.id,
  description: 'コンテスト_Tom_投票中応募0。の説明',
  entry_start_at: now.ago(10.days),
  entry_end_at: now.ago(10.days),
  vote_start_at: now.ago(10.days),
  vote_end_at: now.since(10.days),
  visible_range_entry: 0,
  visible_range_vote: 0,
  visible_range_show: 0,
  visible_range_result: 0,
  voting_points: 3,
  num_of_views_in_result: 3,
  visible_setting_for_user_name: 0,
  limited_url_entry: SecureRandom.alphanumeric(16),
  limited_url_vote: SecureRandom.alphanumeric(16),
  limited_url_show: SecureRandom.alphanumeric(16),
  limited_url_result: SecureRandom.alphanumeric(16),
)
contest_Tom_3.save!(validate: false)

#Tom作成、応募10人、投票0人
contest_Tom_3_1 = Contest.new(
  name: 'コンテスト_Tom_投票中_応募10_投票0人',
  user_id: user_Tom.id,
  description: 'コンテスト_Tom_投票中_応募10_投票0人。の説明',
  entry_start_at: now.ago(10.days),
  entry_end_at: now.ago(10.days),
  vote_start_at: now.ago(10.days),
  vote_end_at: now.since(10.days),
  visible_range_entry: 0,
  visible_range_vote: 0,
  visible_range_show: 0,
  visible_range_result: 0,
  voting_points: 3,
  num_of_views_in_result: 3,
  visible_setting_for_user_name: 0,
  limited_url_entry: SecureRandom.alphanumeric(16),
  limited_url_vote: SecureRandom.alphanumeric(16),
  limited_url_show: SecureRandom.alphanumeric(16),
  limited_url_result: SecureRandom.alphanumeric(16),
)
contest_Tom_3_1.save!(validate: false)

#Tom作成、応募10人、投票10人
contest_Tom_3_2 = Contest.new(
  name: 'コンテスト_Tom_投票中_応募10_投票10人',
  user_id: user_Tom.id,
  description: 'コンテスト_Tom_投票中_応募10_投票10人。の説明',
  entry_start_at: now.ago(10.days),
  entry_end_at: now.ago(10.days),
  vote_start_at: now.ago(10.days),
  vote_end_at: now.since(10.days),
  visible_range_entry: 0,
  visible_range_vote: 0,
  visible_range_show: 0,
  visible_range_result: 0,
  voting_points: 3,
  num_of_views_in_result: 3,
  visible_setting_for_user_name: 0,
  limited_url_entry: SecureRandom.alphanumeric(16),
  limited_url_vote: SecureRandom.alphanumeric(16),
  limited_url_show: SecureRandom.alphanumeric(16),
  limited_url_result: SecureRandom.alphanumeric(16),
)
contest_Tom_3_2.save!(validate: false)

#Ken作成、応募0人
contest_Ken_3 = Contest.new(
  name: 'コンテスト_Ken_投票中応募0',
  user_id: user_Ken.id,
  description: 'コンテスト_Ken_投票中応募0。の説明',
  entry_start_at: now.ago(10.days),
  entry_end_at: now.ago(10.days),
  vote_start_at: now.ago(10.days),
  vote_end_at: now.since(10.days),
  visible_range_entry: 0,
  visible_range_vote: 0,
  visible_range_show: 0,
  visible_range_result: 0,
  voting_points: 3,
  num_of_views_in_result: 3,
  visible_setting_for_user_name: 0,
  limited_url_entry: SecureRandom.alphanumeric(16),
  limited_url_vote: SecureRandom.alphanumeric(16),
  limited_url_show: SecureRandom.alphanumeric(16),
  limited_url_result: SecureRandom.alphanumeric(16),
)
contest_Ken_3.save!(validate: false)

#Ken作成、応募10人、投票0人
contest_Ken_3_1 = Contest.new(
  name: 'コンテスト_Ken_投票中_応募10_投票0人',
  user_id: user_Ken.id,
  description: 'コンテスト_Ken_投票中_応募10_投票0人。の説明',
  entry_start_at: now.ago(10.days),
  entry_end_at: now.ago(10.days),
  vote_start_at: now.ago(10.days),
  vote_end_at: now.since(10.days),
  visible_range_entry: 0,
  visible_range_vote: 0,
  visible_range_show: 0,
  visible_range_result: 0,
  voting_points: 3,
  num_of_views_in_result: 3,
  visible_setting_for_user_name: 0,
  limited_url_entry: SecureRandom.alphanumeric(16),
  limited_url_vote: SecureRandom.alphanumeric(16),
  limited_url_show: SecureRandom.alphanumeric(16),
  limited_url_result: SecureRandom.alphanumeric(16),
)
contest_Ken_3_1.save!(validate: false)

#Ken作成、応募10人、投票10人
contest_Ken_3_2 = Contest.new(
  name: 'コンテスト_Ken_投票中_応募10_投票10人',
  user_id: user_Ken.id,
  description: 'コンテスト_Ken_投票中_応募10_投票10人。の説明',
  entry_start_at: now.ago(10.days),
  entry_end_at: now.ago(10.days),
  vote_start_at: now.ago(10.days),
  vote_end_at: now.since(10.days),
  visible_range_entry: 0,
  visible_range_vote: 0,
  visible_range_show: 0,
  visible_range_result: 0,
  voting_points: 3,
  num_of_views_in_result: 3,
  visible_setting_for_user_name: 0,
  limited_url_entry: SecureRandom.alphanumeric(16),
  limited_url_vote: SecureRandom.alphanumeric(16),
  limited_url_show: SecureRandom.alphanumeric(16),
  limited_url_result: SecureRandom.alphanumeric(16),
)
contest_Ken_3_2.save!(validate: false)





#投票後+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#Tom作成、応募0
contest_Tom_4 = Contest.new(
  name: 'コンテスト_Tom_投票後_応募0',
  user_id: user_Tom.id,
  description: 'コンテスト_Tom_投票後_応募0。の説明',
  entry_start_at: now.ago(10.days),
  entry_end_at: now.ago(10.days),
  vote_start_at: now.ago(10.days),
  vote_end_at: now.ago(10.days),
  visible_range_entry: 0,
  visible_range_vote: 0,
  visible_range_show: 0,
  visible_range_result: 0,
  voting_points: 3,
  num_of_views_in_result: 3,
  visible_setting_for_user_name: 0,
  limited_url_entry: SecureRandom.alphanumeric(16),
  limited_url_vote: SecureRandom.alphanumeric(16),
  limited_url_show: SecureRandom.alphanumeric(16),
  limited_url_result: SecureRandom.alphanumeric(16),
)
contest_Tom_4.save!(validate: false)

#Tom作成、応募10、投票0
contest_Tom_4_1 = Contest.new(
  name: 'コンテスト_Tom_投票後_応募10_投票0',
  user_id: user_Tom.id,
  description: 'コンテスト_Tom_投票後_応募10_投票0。の説明',
  entry_start_at: now.ago(10.days),
  entry_end_at: now.ago(10.days),
  vote_start_at: now.ago(10.days),
  vote_end_at: now.ago(10.days),
  visible_range_entry: 0,
  visible_range_vote: 0,
  visible_range_show: 0,
  visible_range_result: 0,
  voting_points: 3,
  num_of_views_in_result: 3,
  visible_setting_for_user_name: 0,
  limited_url_entry: SecureRandom.alphanumeric(16),
  limited_url_vote: SecureRandom.alphanumeric(16),
  limited_url_show: SecureRandom.alphanumeric(16),
  limited_url_result: SecureRandom.alphanumeric(16),
)
contest_Tom_4_1.save!(validate: false)

#Tom作成、応募10、投票10
contest_Tom_4_2 = Contest.new(
  name: 'コンテスト_Tom_投票後_応募10_投票10',
  user_id: user_Tom.id,
  description: 'コンテスト_Tom_投票後_応募10_投票10。の説明',
  entry_start_at: now.ago(10.days),
  entry_end_at: now.ago(10.days),
  vote_start_at: now.ago(10.days),
  vote_end_at: now.ago(10.days),
  visible_range_entry: 0,
  visible_range_vote: 0,
  visible_range_show: 0,
  visible_range_result: 0,
  voting_points: 3,
  num_of_views_in_result: 3,
  visible_setting_for_user_name: 0,
  limited_url_entry: SecureRandom.alphanumeric(16),
  limited_url_vote: SecureRandom.alphanumeric(16),
  limited_url_show: SecureRandom.alphanumeric(16),
  limited_url_result: SecureRandom.alphanumeric(16),
)
contest_Tom_4_2.save!(validate: false)

#Ken作成、応募0
contest_Ken_4 = Contest.new(
  name: 'コンテスト_Ken_投票後_応募0',
  user_id: user_Ken.id,
  description: 'コンテスト_Ken_投票後_応募0。の説明',
  entry_start_at: now.ago(10.days),
  entry_end_at: now.ago(10.days),
  vote_start_at: now.ago(10.days),
  vote_end_at: now.ago(10.days),
  visible_range_entry: 0,
  visible_range_vote: 0,
  visible_range_show: 0,
  visible_range_result: 0,
  voting_points: 3,
  num_of_views_in_result: 3,
  visible_setting_for_user_name: 0,
  limited_url_entry: SecureRandom.alphanumeric(16),
  limited_url_vote: SecureRandom.alphanumeric(16),
  limited_url_show: SecureRandom.alphanumeric(16),
  limited_url_result: SecureRandom.alphanumeric(16),
)
contest_Ken_4.save!(validate: false)

#Ken作成、応募10、投票0
contest_Ken_4_1 = Contest.new(
  name: 'コンテスト_Ken_投票後_応募10_投票0',
  user_id: user_Ken.id,
  description: 'コンテスト_Ken_投票後_応募10_投票0。の説明',
  entry_start_at: now.ago(10.days),
  entry_end_at: now.ago(10.days),
  vote_start_at: now.ago(10.days),
  vote_end_at: now.ago(10.days),
  visible_range_entry: 0,
  visible_range_vote: 0,
  visible_range_show: 0,
  visible_range_result: 0,
  voting_points: 3,
  num_of_views_in_result: 3,
  visible_setting_for_user_name: 0,
  limited_url_entry: SecureRandom.alphanumeric(16),
  limited_url_vote: SecureRandom.alphanumeric(16),
  limited_url_show: SecureRandom.alphanumeric(16),
  limited_url_result: SecureRandom.alphanumeric(16),
)
contest_Ken_4_1.save!(validate: false)

#Ken作成、応募10、投票10
contest_Ken_4_2 = Contest.new(
  name: 'コンテスト_Ken_投票後_応募10_投票10',
  user_id: user_Ken.id,
  description: 'コンテスト_Ken_投票後_応募10_投票10。の説明',
  entry_start_at: now.ago(10.days),
  entry_end_at: now.ago(10.days),
  vote_start_at: now.ago(10.days),
  vote_end_at: now.ago(10.days),
  visible_range_entry: 0,
  visible_range_vote: 0,
  visible_range_show: 0,
  visible_range_result: 0,
  voting_points: 3,
  num_of_views_in_result: 3,
  visible_setting_for_user_name: 0,
  limited_url_entry: SecureRandom.alphanumeric(16),
  limited_url_vote: SecureRandom.alphanumeric(16),
  limited_url_show: SecureRandom.alphanumeric(16),
  limited_url_result: SecureRandom.alphanumeric(16),
)
contest_Ken_4_2.save!(validate: false)




#写真
10.times do |n|
  Photo.create!(
    name: Faker::Food.dish,
    description: Faker::Food.description,
    user_id: user_Tom.id,
    contest_id: contest_Tom_1_1.id,
    camera: 'Canonのカメラ',
    lens: 'Canonのレンズ',
    iso: '200',
    aperture: '2.0',
    shutter_speed: '1/1600',
    image: open("#{Rails.root}/db/fixtures/IMG_7399.JPG")
  )
  Photo.create!(
    name: Faker::Food.dish,
    description: Faker::Food.description,
    user_id: user_Tom.id,
    contest_id: contest_Ken_1_1.id,
    camera: 'Canonのカメラ',
    lens: 'Canonのレンズ',
    iso: '200',
    aperture: '2.0',
    shutter_speed: '1/1600',
    image: open("#{Rails.root}/db/fixtures/IMG_7399.JPG")
  )

  Photo.create!(
    name: Faker::Food.dish,
    description: Faker::Food.description,
    user_id: user_Tom.id,
    contest_id: contest_Tom_2_1.id,
    camera: 'Canonのカメラ',
    lens: 'Canonのレンズ',
    iso: '200',
    aperture: '2.0',
    shutter_speed: '1/1600',
    image: open("#{Rails.root}/db/fixtures/IMG_7399.JPG")
  )
  Photo.create!(
    name: Faker::Food.dish,
    description: Faker::Food.description,
    user_id: user_Tom.id,
    contest_id: contest_Ken_2_1.id,
    camera: 'Canonのカメラ',
    lens: 'Canonのレンズ',
    iso: '200',
    aperture: '2.0',
    shutter_speed: '1/1600',
    image: open("#{Rails.root}/db/fixtures/IMG_7399.JPG")
  )

  Photo.create!(
    name: Faker::Food.dish,
    description: Faker::Food.description,
    user_id: user_Tom.id,
    contest_id: contest_Tom_3_1.id,
    camera: 'Canonのカメラ',
    lens: 'Canonのレンズ',
    iso: '200',
    aperture: '2.0',
    shutter_speed: '1/1600',
    image: open("#{Rails.root}/db/fixtures/IMG_7399.JPG")
  )
  photo = Photo.create!(
    name: Faker::Food.dish,
    description: Faker::Food.description,
    user_id: user_Tom.id,
    contest_id: contest_Tom_3_2.id,
    camera: 'Canonのカメラ',
    lens: 'Canonのレンズ',
    iso: '200',
    aperture: '2.0',
    shutter_speed: '1/1600',
    image: open("#{Rails.root}/db/fixtures/IMG_7399.JPG")
  )
  rand(0..2).times do |n|
    Vote.create!(
      contest_id: contest_Tom_3_2.id,
      photo_id: photo.id,
      user_id: user_Tom.id,
      point: rand(1..3)
    )
  end
  Photo.create!(
    name: Faker::Food.dish,
    description: Faker::Food.description,
    user_id: user_Tom.id,
    contest_id: contest_Ken_3_1.id,
    camera: 'Canonのカメラ',
    lens: 'Canonのレンズ',
    iso: '200',
    aperture: '2.0',
    shutter_speed: '1/1600',
    image: open("#{Rails.root}/db/fixtures/IMG_7399.JPG")
  )
  photo = Photo.create!(
    name: Faker::Food.dish,
    description: Faker::Food.description,
    user_id: user_Tom.id,
    contest_id: contest_Ken_3_2.id,
    camera: 'Canonのカメラ',
    lens: 'Canonのレンズ',
    iso: '200',
    aperture: '2.0',
    shutter_speed: '1/1600',
    image: open("#{Rails.root}/db/fixtures/IMG_7399.JPG")
  )
  rand(0..2).times do |n|
    Vote.create!(
      contest_id: contest_Ken_3_2.id,
      photo_id: photo.id,
      user_id: user_Tom.id,
      point: rand(1..3)
    )
  end

  Photo.create!(
    name: Faker::Food.dish,
    description: Faker::Food.description,
    user_id: user_Tom.id,
    contest_id: contest_Tom_4_1.id,
    camera: 'Canonのカメラ',
    lens: 'Canonのレンズ',
    iso: '200',
    aperture: '2.0',
    shutter_speed: '1/1600',
    image: open("#{Rails.root}/db/fixtures/IMG_7399.JPG")
  )
  photo = Photo.create!(
    name: Faker::Food.dish,
    description: Faker::Food.description,
    user_id: user_Tom.id,
    contest_id: contest_Tom_4_2.id,
    camera: 'Canonのカメラ',
    lens: 'Canonのレンズ',
    iso: '200',
    aperture: '2.0',
    shutter_speed: '1/1600',
    image: open("#{Rails.root}/db/fixtures/IMG_7399.JPG")
  )
  rand(0..2).times do |n|
    Vote.create!(
      contest_id: contest_Tom_4_2.id,
      photo_id: photo.id,
      user_id: user_Tom.id,
      point: rand(1..3)
    )
  end
  Photo.create!(
    name: Faker::Food.dish,
    description: Faker::Food.description,
    user_id: user_Tom.id,
    contest_id: contest_Ken_4_1.id,
    camera: 'Canonのカメラ',
    lens: 'Canonのレンズ',
    iso: '200',
    aperture: '2.0',
    shutter_speed: '1/1600',
    image: open("#{Rails.root}/db/fixtures/IMG_7399.JPG")
  )
  photo = Photo.create!(
    name: Faker::Food.dish,
    description: Faker::Food.description,
    user_id: user_Tom.id,
    contest_id: contest_Ken_4_2.id,
    camera: 'Canonのカメラ',
    lens: 'Canonのレンズ',
    iso: '200',
    aperture: '2.0',
    shutter_speed: '1/1600',
    image: open("#{Rails.root}/db/fixtures/IMG_7399.JPG")
  )
  rand(0..2).times do |n|
    Vote.create!(
      contest_id: contest_Ken_4_2.id,
      photo_id: photo.id,
      user_id: user_Tom.id,
      point: rand(1..3)
    )
  end
end


# #ダミーデータ++++++++++++++++++++++++++++++++++++++++
# 40.times do |n|
#   #ユーザ
#   name  = Faker::Name.name
#   user_id = "example-#{n+1}@example.com"
#   password = "password#{n+1}"
#   user = User.create!(name:                  name,
#                       user_id:                 user_id,
#                       password:              password,
#                       password_confirmation: password)
#   #コンテスト
#   rand(5).times do |n|
#     name  = Faker::Food.dish
#     description  = Faker::Food.description
#     I18n.locale = 'ja'
#     Faker::Time.between(from: DateTime.now - 1, to: DateTime.now, format: :default)
#     contest = Contest.create!(name:    name,
#                               user_id: user.id,
#                               description: description,
#                               entry_start_at:
#                             )
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
