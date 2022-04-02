require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  describe "#new" do
    it "パスワード変更リクエストページが表示される" do
      get new_password_reset_path
      expect(response).to have_http_status(200)
    end
  end
  describe "#create" do
    let(:user) { create(:user) }
    before do
      ActionMailer::Base.deliveries.clear
    end

    context "無効なメールアドレスを送信した場合" do
      it "再設定用のメールは送信されず、ビューが再描画される" do
        post password_resets_path, params: { password_reset: { email: "" } }
        expect(ActionMailer::Base.deliveries.size).to eq 0
        expect(response).to render_template('password_resets/new')
        expect(flash).not_to be_empty
      end
    end

    context "有効なメールアドレスを送信した場合" do
      it "再設定用のメールが送信される" do
        post password_resets_path, params: { password_reset: { email: user.email } }
        expect(ActionMailer::Base.deliveries.size).to eq 1
        expect(response).to redirect_to root_url
        expect(flash).not_to be_empty
      end
    end
  end

  describe "#edit" do
    # let(:user) { create(:user) }
    context "無効な値の場合" do
      it "メールアドレスが無効であれば、リダイレクトされる" do
        user = create(:user, :password_reset)
        get edit_password_reset_url(user.reset_token, email: "")
        expect(response).to redirect_to root_url
      end

      it "有効化していないユーザーであれば、リダイレクトされる" do
        user = create(:user, :password_reset)
        # 有効化していない状態にする(true → false)
        user.toggle!(:activated)
        get edit_password_reset_url(user.reset_token, email: user.email)
        expect(response).to redirect_to root_url
      end

      it "メールアドレスが有効で、トークンが無効の場合は、リダイレクトされる" do
        user = create(:user, :password_reset)
        get edit_password_reset_url('wrong token', email: user.email)
        expect(response).to redirect_to root_url
      end

      it "パスワード設定期限が切れていた場合は、リダイレクトされる" do
        user = create(:user, :password_reset, reset_sent_at: 3.hours.ago)
        get edit_password_reset_url(user.reset_token, email: user.email)
        expect(response).to redirect_to new_password_reset_url
      end
    end

    context "有効な値の場合" do
      it "メールアドレスとトークン両方が有効の場合、再設定フォームが表示される" do
        user = create(:user, :password_reset)
        get edit_password_reset_url(user.reset_token, email: user.email)
        expect(response).to have_http_status(200)
        expect(response).to render_template 'password_resets/edit'
      end
    end
  end

  describe "#update" do
  let(:user) { create(:user, :password_reset) }
    context "無効な値の場合" do
      it "パスワードが無効であれば、パスワードが更新されない" do
        patch password_reset_path(user.reset_token),
              params: { email: user.email,
                        user: { password: 'foobaz',
                                password_confirmation: 'invalid' } }
        expect(response).to render_template 'password_resets/edit'
        user.reload
        expect(user.authenticate('foobar')).to be_truthy
      end

      it "パスワードが空であれば、パスワードが更新されない" do
        patch password_reset_path(user.reset_token),
        params: { email: user.email,
                  user: { password: '',
                          password_confirmation: '' } }
        expect(response).to render_template 'password_resets/edit'
        user.reload
        expect(user.authenticate('foobar')).to be_truthy
      end
      
      it "パスワード更新期限が切れていれば、パスワードが更新されない" do
        user.update_attribute(:reset_sent_at, 3.hours.ago)
        patch password_reset_path(user.reset_token),
              params: { email: user.email,
                        user: { password: 'newpass',
                                password_confirmation: 'newpass' } }
        expect(response).to redirect_to new_password_reset_url
        user.reload
        expect(user.authenticate('foobar')).to be_truthy
      end
    end

    context "有効な値の場合" do
      it "有効なパスワードと確認パスワードであれば、パスワードが更新される" do
        patch password_reset_url(user.reset_token),
              params: { email: user.email,
                        user: { password: 'newpass',
                                password_confirmation: 'newpass' } }
        expect(logged_in?).to eq true
        expect(response).to redirect_to user_path(user)
        expect(flash).not_to be_empty
        user.reload
        expect(user.authenticate('newpass')).to be_truthy
        expect(user.reset_digest).to be_nil
      end
    end
  end
end
