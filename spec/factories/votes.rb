FactoryBot.define do
  factory :vote, class: Vote do
    association   :contest, factory: :contest
    association   :photo, factory: :photo
    association   :user, factory: :user
    point        { 3 }
  end
end
