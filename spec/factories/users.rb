FactoryBot.define do
  factory :user, class: User do
    name { 'username' }
    email { 'user@example.com' }
    password { 'foobar' }
    password_confirmation { 'foobar' }
  end

  factory :other_user, class: User do
    name { 'other_username' }
    email { 'other.user@example.com' }
    password { 'otherfoobar' }
    password_confirmation { 'otherfoobar' }
  end

  factory :japanese_user, class: User do
    name { '日本語ユーザ' }
    email { 'japanese.user@example.com' }
    password { 'foobar' }
    password_confirmation { 'foobar' }
  end
end
