FactoryBot.define do
  factory :ranking do
    association :movie
    reservation_count { 100 }
    date { Date.today }
  end
end