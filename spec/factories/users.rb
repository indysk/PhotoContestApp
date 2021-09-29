FactoryBot.define do
  factory :user, class: User do
    name { 'username' }
    user_id { 'user_id' }
    password { 'foobar' }
    password_confirmation { 'foobar' }
  end

  factory :other_user, class: User do
    name { 'other_username' }
    user_id { 'other_user_id' }
    password { 'otherfoobar' }
    password_confirmation { 'otherfoobar' }
  end

  factory :japanese_user, class: User do
    name { '日本語ユーザ' }
    user_id { 'japanese_user_id' }
    password { 'foobar' }
    password_confirmation { 'foobar' }
  end
end
