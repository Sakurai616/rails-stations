FactoryBot.define do
  factory :reservation do
    association :user
    association :schedule
    association :sheet

    date { Date.today }
  end
end
