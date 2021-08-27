FactoryBot.define do
  factory :photo, class: Photo do
    name { "Photo_Name" }
    association :contest, factory: :contest
    user { contest.user }
  end

  factory :other_photo, class: Photo do
    name { "OtherPhoto_Name" }
    association :contest, factory: :other_contest
    user { contest.user }
  end

  factory :japanese_photo, class: Photo do
    name { "写真" }
    association :contest, factory: :japanese_contest
    user { contest.user }
  end

  factory :duplication_photo, class: Photo do
    name { "DuplicationPhoto_Name" }
    association :contest, factory: :contest
    user { contest.user }
  end
end
