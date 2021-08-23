FactoryBot.define do
  factory :photo, class: Photo do
    name { "MyString" }
    contest { nil }
    user { nil }
  end
end
