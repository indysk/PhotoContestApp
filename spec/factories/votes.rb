FactoryBot.define do
  factory :vote, class: Vote do
    contest { nil }
    photo { nil }
    user { nil }
  end
end
