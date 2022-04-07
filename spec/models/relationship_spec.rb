require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let!(:user){ create(:user) }
  let!(:another_user){ create(:another_user) }
  let(:relationship){ user.active_relationships.build(followed_id: another_user.id)}

  it "正しい関係であれば、フォローする関係は有効になる" do
    expect(relationship).to be_valid
  end

  it "フォローするユーザーがいなければ、フォローする関係は無効になる" do
    relationship.follower_id = nil
    expect(relationship).not_to be_valid
  end

  it "フォローされるユーザーがいなければ、フォローする関係は無効になる" do
    relationship.followed_id = nil
    expect(relationship).not_to be_valid
  end
end
