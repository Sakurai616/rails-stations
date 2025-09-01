FactoryBot.define do
  factory :schedule do
    start_time { Time.current }
    end_time { Time.current.since(30.minutes) }

    association :movie
    association :screen
  end
end
