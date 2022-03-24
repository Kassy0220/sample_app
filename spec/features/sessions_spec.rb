require 'rails_helper'

RSpec.feature "Sessions", type: :feature do
  given!(:user) { create(:user) }
  given(:params) { { email: email, password: password } }
  background do
    visit login_path
    fill_in 'Email', with: params[:email]
    fill_in 'Password', with: params[:password]
  end
  
  feature "ログイン成功時のテスト" do
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
  
  feature "フラッシュメッセージのテスト" do
    given(:email) { "" }
    given(:password) { "" }
    scenario "ログイン失敗のフラッシュメッセージはページ遷移で消える" do
      click_button "Log in"
      expect(page).to have_current_path(login_path)
      expect(page).to have_content 'Invalid email/password combination'
      visit root_path
      expect(page).not_to have_content 'Invalid email/password combination'
    end
  end

  feature "パスワードが無効であればログインできない" do
    given(:email) { 'user@example.com' }
    given(:password) { 'invalid' }
    scenario "ログイン失敗時のテスト" do
      click_button "Log in"
      expect(page).to have_current_path(login_path)
      expect(page).to have_link 'Log in'
      expect(page).not_to have_link 'Profile'
      expect(page).not_to have_link 'Log out'
    end
  end

end
