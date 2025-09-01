FactoryBot.define do
  factory :sheet do
    row { 'A' }
    column { 1 }

    association :screen
  end
end
