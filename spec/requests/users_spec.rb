require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "#new" do
    it "ユーザー登録ページが表示される" do
      get signup_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /users" do
    let(:user) { attributes_for(:user) }
    before do
      ActionMailer::Base.deliveries.clear
    end
    it "ユーザー登録が成功したら、リダイレクトされる" do
      expect {
        post users_path, params: { user: user }
      }.to change(User, :count).by(1)
      expect(ActionMailer::Base.deliveries.size).to eq(1)
      expect(response).to redirect_to root_url
      expect(logged_in?).to eq false
    end
  end

  describe "#create " do
    let(:user) { create(:user, :no_activated) }

    context "アカウントを有効化していない場合" do
      it "ログインできない" do
        log_in_as(user)
        expect(logged_in?).not_to eq true
      end
    end

    context "有効化トークンが無効な場合" do
      it "有効化できずログインできない" do
        get edit_account_activation_path('invalid token', email: user.email)
        expect(logged_in?).to eq false
        expect(response).to redirect_to root_url
      end
    end

    context "トークンは正しいが、メールアドレスが無効な場合" do
      it "有効化できずログインできない" do
        get edit_account_activation_path(user.activation_token, email: 'wrong')
        expect(logged_in?).to eq false
        expect(response).to redirect_to root_url
      end
    end

    context "トークン、メールアドレス両方が有効な場合" do
      it "ログインできる" do
        get edit_account_activation_path(user.activation_token, email: user.email)
        expect(logged_in?).to eq true
        expect(response).to redirect_to user
      end
    end
  end

  describe "#edit" do
    let(:user) { create(:user) }
    let(:another_user) { create(:another_user) }
    it "非ログイン状態で編集ページを開くとリダイレクトされる" do
      get edit_user_path(user)
      expect(flash).not_to be_empty
      expect(response).to redirect_to login_url
    end

    it "他のユーザーの編集ページを開こうとすると、リダイレクトされる" do
      log_in_as(another_user)
      get edit_user_path(user)
      expect(flash).not_to be_empty
      expect(response).to redirect_to root_url
    end

    it "編集ページでフレンドリーフォワーディングが行われる" do
      get edit_user_path(user)
      log_in_as(user)
      expect(response).to redirect_to edit_user_path(user)
      delete logout_path
      expect(response).to redirect_to root_url
      # フレンドリーフォーワーディングされない場合
      log_in_as(user)
      expect(session[:forwarding_url]).to eq nil
    end
  end

  describe "#update" do
    context "ユーザー情報更新失敗時のテスト" do
      let(:user) { create(:user) }
      let(:another_user) { create(:another_user) }
      it "非ログイン状態で編集リクエストを送ると、リダイレクトされる" do
        patch user_path(user), params: { user: { name: user.name,
                                                 email: user.email }}
        expect(flash).not_to be_empty
        expect(response).to redirect_to login_url
      end

      it "他のユーザーの編集リクエストを送ると、リダイレクトされる" do
        log_in_as(another_user)
        patch user_path(user), params: { user: { name: user.name,
                                                 email: user.email }}
        expect(flash).not_to be_empty
        expect(response).to redirect_to root_url
      end
      it "無効な値の場合は、更新ができない" do
        log_in_as(user)
        get edit_user_path(user)
        patch user_path(user), params: { user: { name: "",
                                                 email: "foo@valid",
                                                 password: "foo",
                                                 password_confirmation: "bar"} }
        expect(response).to render_template('users/edit')
      end

      it "ユーザーはadmin属性を変更することができない" do
        log_in_as(another_user)
        expect(another_user.admin?).not_to eq true
        patch user_path(another_user), params: { 
                                          user: { password: "password",
                                                  password_confirmation: "password",
                                                  admin: true } }
        another_user.reload
        expect(another_user.admin?).not_to eq true
      end
    end

    context "ユーザー情報更新成功時のテスト" do
      let(:user) { create(:user) }
      it "有効な値の場合は、更新できる" do
        log_in_as(user)
        patch user_path(user), params: { user: { name: "Edited User",
                                                 email: "edited@example.com",
                                                 password: "",
                                                 password_confirmation: ""} }
        expect(response).to redirect_to user_path(user)
        expect(flash).not_to be_empty 
        user.reload
        expect(user.name).to eq 'Edited User'
        expect(user.email).to eq 'edited@example.com'
      end
    end
  end

  describe "#index" do
    it "非ログイン状態で一覧ページにアクセスすると、リダイレクトされる" do
      get users_path
      expect(response).to redirect_to login_url
    end
  end

  describe "#destroy" do
    let!(:user) { create(:user) }
    let(:another_user) { create(:another_user) }
    it "非ログイン状態で削除リクエストを送ると、リダイレクトされる" do
      expect(User.count).to eq 1
      expect {
        delete user_path(user)
      }.to change(User, :count).by(0)
      expect(response).to redirect_to login_url
    end

    it "管理者でないユーザーは、削除リクエストを送るとリダイレクトされる" do
      log_in_as(another_user)
      expect {
        delete user_path(user)
      }.to change(User, :count).by(0)
      expect(response).to redirect_to root_url
    end
  end

  describe "#following" do
    it "非ログイン状態でフォローしているユーザーのページを開こうとすると、リダイレクトされる" do
      user = create(:user)
      get following_user_path(user)
      expect(response).to redirect_to login_url
    end
  end

  describe "#followers" do
    it "非ログイン状態でフォロワーのページを開こうとすると、リダイレクトされる" do
      user = create(:user)
      get followers_user_path(user)
      expect(response).to redirect_to login_url
    end
  end
end
