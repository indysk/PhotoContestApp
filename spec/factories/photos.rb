FactoryBot.define do
  factory :photo, class: Photo do
    name { "Photo_Name" }
    association :contest, factory: :contest
    association :user, factory: :user
  end

  factory :other_photo, class: Photo do
    name { "OtherPhoto_Name" }
    association :contest, factory: :other_contest
    association :user, factory: :other_user
  end

  factory :japanese_photo, class: Photo do
    name { "写真" }
    association :contest, factory: :japanese_contest
    association :user, factory: :japanese_user
  end

  # 10.times do |n|
  #   factory :"photo#{n}", class: Photo do
  #     name { Faker::Movie.title }
  #     association :contest, factory: :contest
  #     association :user, factory: :"user#{n}"
  #   end
  # end
end
