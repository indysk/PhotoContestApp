FactoryBot.define do
  factory :contest, class: Contest do
    name { "User_Contest" }
    association :user, factory: :user
  end

  factory :other_contest, class: Contest do
    name { "OtherUser_Contest" }
    association :user, factory: :other_user
  end

  factory :japanese_contest, class: Contest do
    name { "コンテスト" }
    association :user, factory: :japanese_user
  end
end
