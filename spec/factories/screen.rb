FactoryBot.define do
  factory :screen do
    association :theater
    number { 1 }
  end
end
