FactoryBot.define do
  factory :contest, class: Contest do
    name { "User_Contest" }
    association :user, factory: :user
    association :user, factory: :user
  end
  contest_Tom_0 = Contest.create!(
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
    visible_setting_for_user_name: 0
  )

  factory :other_contest, class: Contest do
    name { "OtherUser_Contest" }
    association :user, factory: :other_user
  end

  factory :japanese_contest, class: Contest do
    name { "コンテスト" }
    association :user, factory: :japanese_user
  end
end
