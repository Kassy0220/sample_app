require 'rails_helper'

RSpec.feature "Sessions", type: :feature do
  given!(:user) { create(:user) }
  given(:params) { { email: email, password: password } }
  background do
    visit login_path
    fill_in 'Email', with: params[:email]
    fill_in 'Password', with: params[:password]
  end
  
  feature "#create" do
    context "ログイン成功時" do
    end
    context "ログイン失敗時" do
    end
  end
  
  feature "#create successfully" do
    given(:email) { 'user@example.com' }
    given(:password) { 'foobar' }

    scenario "有効な情報であればログインできる" do
      click_button "Log in"
      expect(page).to have_current_path(user_path(user))
      expect(page).not_to have_link 'Log in'
      expect(page).to have_link 'Profile'
      expect(page).to have_link 'Log out'
    end
    
    scenario "ログインした状態からログアウトできる" do
      click_button "Log in"
      click_link "Log out"
      expect(page).to have_current_path(root_path)
      expect(page).to have_link 'Log in'
      expect(page).not_to have_link 'Profile'
      expect(page).not_to have_link 'Log out'
    end
  end

  feature "#create unsuccessfully" do
    context "メールアドレスとパスワードが両方無効な値の場合" do
      given(:email) { "" }
      given(:password) { "" }
      scenario "ログインに失敗し、フラッシュメッセージが1度表示される" do
        click_button "Log in"
        expect(page).to have_current_path(login_path)
        expect(page).to have_content 'Invalid email/password combination'
        visit root_path
        expect(page).not_to have_content 'Invalid email/password combination'
      end
    end

    context "パスワードが無効な値の場合" do
      given(:email) { "user@example.com" }
      given(:password) { "invalid" }
      scenario "ログインに失敗する" do
        click_button "Log in"
        expect(page).to have_current_path(login_path)
        expect(page).to have_link 'Log in'
        expect(page).not_to have_link 'Profile'
        expect(page).not_to have_link 'Log out'
      end
    end
  end

end
