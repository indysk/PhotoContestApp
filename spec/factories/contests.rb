FactoryBot.define do
  now = Time.current

  # contest = Contest.new(name: 'contest', user: User.first, description: 'contest description', entry_start_at: Time.current + 1.day, entry_end_at: Time.current + 2.day, vote_start_at: Time.current + 3.day, vote_end_at: Time.current + 4.day, visible_range_entry: 0, visible_range_vote: 0, visible_range_show: 0, visible_range_result: 0, voting_points: 3, num_of_views_in_result: 3, visible_setting_for_user_name: 0, limited_url_entry: 'e' * 16, limited_url_vote: 'v' * 16, limited_url_show: 's' * 16, limited_url_result: 'r' * 16)
  factory :contest, class: Contest do
    name { "User_Contest" }
    association :user, factory: :user
    description { "contest description" }
    entry_start_at { now.since(1.days) }
    entry_end_at { now.since(2.days) }
    vote_start_at { now.since(3.days) }
    vote_end_at { now.since(4.days) }
    visible_range_entry { 0 }
    visible_range_vote { 0 }
    visible_range_show { 0 }
    visible_range_result { 0 }
    voting_points { 3 }
    num_of_views_in_result { 3 }
    num_of_submit_limit { 1 }
    visible_setting_for_user_name { 0 }
    limited_url_entry { "e" * 16 }
    limited_url_vote { "v" * 16 }
    limited_url_show { "s" * 16 }
    limited_url_result { "r" * 16 }
  end

  factory :other_contest, class: Contest do
    name { "Other_User_Contest" }
    association :user, factory: :user
    description { "other contest description" }
    entry_start_at { now.since(1.days) }
    entry_end_at { now.since(2.days) }
    vote_start_at { now.since(3.days) }
    vote_end_at { now.since(4.days) }
    visible_range_entry { 0 }
    visible_range_vote { 0 }
    visible_range_show { 0 }
    visible_range_result { 0 }
    voting_points { 3 }
    num_of_views_in_result { 3 }
    num_of_submit_limit { 1 }
    visible_setting_for_user_name { 0 }
    limited_url_entry { "e" * 16 }
    limited_url_vote { "v" * 16 }
    limited_url_show { "s" * 16 }
    limited_url_result { "r" * 16 }
  end

  factory :japanese_contest, class: Contest do
    name { "日本語のコンテスト" }
    association :user, factory: :user
    description { "コンテストの説明" }
    entry_start_at { now.since(1.days) }
    entry_end_at { now.since(2.days) }
    vote_start_at { now.since(3.days) }
    vote_end_at { now.since(4.days) }
    visible_range_entry { 0 }
    visible_range_vote { 0 }
    visible_range_show { 0 }
    visible_range_result { 0 }
    voting_points { 3 }
    num_of_views_in_result { 3 }
    num_of_submit_limit { 1 }
    visible_setting_for_user_name { 0 }
    limited_url_entry { "e" * 16 }
    limited_url_vote { "v" * 16 }
    limited_url_show { "s" * 16 }
    limited_url_result { "r" * 16 }
  end
end
