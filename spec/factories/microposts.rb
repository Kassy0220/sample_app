FactoryBot.define do
  factory :micropost, class: Micropost do
    content {"Test Text"}
    association :user

    trait :ten_minutes_ago do
      content{"10 minutes ago"}
      created_at {10.minutes.ago}
    end

    trait :two_years_ago do
      content{"2 years ago"}
      created_at {2.years.ago}
    end

    trait :now do
      content{"Now!"}
      created_at {Time.zone.now}
    end
  end

  # sequence :serial_content do |i|
  #   "Text number-#{i}"
  # end

  factory :serial_microposts, class: Micropost do
    i = 1
    sequence(:content){ |i| "Text number-#{i}" }
    association :user
  end
end
