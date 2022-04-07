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

  factory :serial_microposts, class: Micropost do
    sequence(:content){ |i| "Text number-#{i}" }
    association :user
  end
end

def create_microposts(user, number)
  microposts = build_list(:serial_microposts, number, created_at: Time.current, updated_at: Time.current, user: user)
  Micropost.insert_all microposts.map(&:attributes)
end
