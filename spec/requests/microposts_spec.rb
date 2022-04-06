require 'rails_helper'

RSpec.describe "Microposts", type: :request do
  describe "#create" do
    let!(:user) { create(:user) }
    let!(:micropost) { create(:micropost, user: user)}
    it "非ログイン状態でマイクロポストを作成しようとすると、リダイレクトされる" do
      expect {
        post microposts_path
      }.to change(Micropost, :count).by 0
      expect(response).to redirect_to login_url
    end
  end

  describe "#destroy" do
    let!(:user) { create(:user) }
    let!(:micropost) { create(:micropost, user: user)}
    it "非ログイン状態でマイクロポストを削除しようとすると、リダイレクトされる" do
      expect {
        delete micropost_path(micropost)
      }.to change(Micropost, :count).by 0
      expect(response).to redirect_to login_url
    end

    it "他人のマイクロポストを削除しようとすると、リダイレクトされる" do
      another_user = create(:another_user)
      another_micropost = create(:micropost, user: another_user)
      log_in_as(user)
      expect {
        delete micropost_path(another_micropost)
      }.to change(another_user.microposts, :count).by 0
      expect(response).to redirect_to root_url
    end
  end
end
