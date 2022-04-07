FactoryBot.define do
  factory :following, class: Relationship do
    follower_id { 1 }
    sequence(:followed_id, 2) { |n| n }
  end

  factory :follower, class: Relationship do
    sequence(:follower_id, 2) { |n| n}
    followed_id { 1 }
  end
end

def create_relationships(user, number) 
  serial_users = create_list(:serial_user, number)
  serial_users.each do |u|
    user.active_relationships.create(followed_id: u.id)
    user.passive_relationships.create(follower_id: u.id)
  end
end
