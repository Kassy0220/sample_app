require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:micropost) { create(:micropost) }

  context "valid valur" do
    it "有効な値であれば、有効になる" do
      expect(micropost).to be_valid
    end
  end

  context "user_id" do
    it "ユーザーIDが存在しなければ、無効になる" do
      micropost.user_id = nil
      expect(micropost).not_to be_valid
    end
  end

  context "content" do
    it "投稿内容が存在していなければ、無効になる" do
      micropost.content = ""
      expect(micropost).not_to be_valid
    end

    it "投稿内容が140文字を超えている場合は、無効になる" do
      micropost.content = "a" * 141
      expect(micropost).not_to be_valid
    end
  end


  context "created_at" do
    let(:user) {create(:user)}
    let!(:ten_minutes_ago) { create(:micropost, :ten_minutes_ago, user: user) }
    let!(:now) { create(:micropost, :now, user: user) }
    let!(:two_years_ago) { create(:micropost, :two_years_ago, user: user) }
    it "投稿は、作成された時間が新しいものから順に取得される" do
      first = Micropost.first
      expect(first).to eq now
    end
  end
end
