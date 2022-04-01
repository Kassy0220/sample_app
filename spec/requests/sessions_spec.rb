require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "#new" do
    it "ログインページが表示される" do
      get login_path
      expect(response).to have_http_status(200)
    end
  end

  describe "#create" do
    let(:user) { create(:user) }
    it "cookieを保存してログインできる" do
      log_in_as(user)
      expect(cookies[:remember_token]).to eq assigns(:user).remember_token
    end

    it "cookieを削除してログインできる" do
      # 一旦cookieを保存してログイン
      log_in_as(user)
      delete logout_path
      # cookieを削除してログイン
      log_in_as(user, remember_me: '0')
      expect(cookies[:remember_token]).to be_empty
    end
  end

  describe "#destroy" do
    let!(:user) { create(:user) }
    it "複数のウィンドウで正常にログアウトできる" do
      post login_path, params: { session: { email: 'user@example.com',
                                            password: 'foobar' } }
      expect(response).to have_http_status(302)
      expect(response).to redirect_to user_path(user)
      delete logout_path
      expect(logged_in?).to be_falsy
      expect(response).to redirect_to root_url
      # 2つ目のウィンドウでログアウトを行う
      delete logout_path
      expect(response).to redirect_to root_url
      expect(logged_in?).to be_falsy
    end
  end
end
