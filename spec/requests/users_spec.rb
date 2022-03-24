require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "user_page responds successfully" do
    let(:user) { attributes_for(:user) }
    it "ユーザー登録ページが表示される" do
      get signup_path
      expect(response).to have_http_status(200)
    end

    it "ユーザー登録時が成功したら、ログインする" do
      expect {
        post users_path, params: {user: user}
      }.to change(User, :count).by(1)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to user_path(User.last)
      expect(logged_in?).to be_truthy
    end
  end

end
