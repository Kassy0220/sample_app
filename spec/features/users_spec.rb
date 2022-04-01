require 'rails_helper'

RSpec.feature "Users", type: :feature do
  feature "#create" do
    scenario "無効な値の場合は、ユーザー登録できない" do
      visit signup_path
      expect {
        fill_in 'Name', with: ""
        fill_in 'Email', with: "user@invalid"
        fill_in 'Password', with: "foo"
        fill_in 'Confirmation', with: "bar"
        click_on 'Create my account'
      }.to change(User, :count).by(0)
      expect(page).to have_css '#error_explanation'
      expect(page).to have_css '.alert'
    end

    # テストをスキップ
    xscenario "有効な値の場合は、ユーザー登録される" do
      visit signup_path
      expect {
        fill_in 'Name', with: "Example User"
        fill_in 'Email', with: "user@example.com"
        attach_file "Avatar", "#{Rails.root}/spec/files/avatar.png"
        fill_in 'Password', with: "foobar"
        fill_in 'Confirmation', with: "foobar"
        click_on 'Create my account'
      }.to change(User, :count).by(1)
      visit edit_account_activation_path(token, email: user.email)
      expect(page).to have_current_path(user_path(user))
      expect(page).to have_content 'Welcome to the Sample App!'
      expect(page).to have_selector("img[src$='avatar.png']")
    end
  end

  feature "#index" do
    given!(:user) { create(:user) }
    background do
      users = build_list(:serial_user, 30, created_at: Time.current, updated_at: Time.current)
      User.insert_all users.map(&:attributes)
    end
    scenario "ログイン済みのユーザーはユーザー一覧ページが表示される" do
      visit login_path
      fill_in 'Email', with: "user@example.com"
      fill_in 'Password', with: "foobar"
      click_button 'Log in'
      visit users_path
      expect(page).to have_current_path users_path
      expect(page.all('.pagination').count).to eq 2
      User.all.page(1).each do |user|
        expect(page).to have_link "#{user.name}"
      end
    end
  end

  feature "#update" do
    given!(:user) { create(:user, :with_valid_avatar) }
    scenario "ユーザー画像を更新すると、新しい画像が表示される" do
      visit login_path
      fill_in 'Email', with: "user@example.com"
      fill_in 'Password', with: "foobar"
      click_button 'Log in'
      visit edit_user_path(user)
      expect(page).to have_selector ("img[src$='avatar.png']")
      fill_in 'Email', with: "user@example.com"
      fill_in 'Password', with: "foobar"
      attach_file 'Avatar', "#{Rails.root}/spec/files/newavatar.png"
      click_button 'Save changes'
      expect(page).to have_current_path(user_path(user))
      expect(page).to have_selector ("img[src$='newavatar.png']")
    end
  end

  feature "#destroy" do
    given!(:user) { create(:user) }
    given!(:another_user) { create(:another_user) }
    scenario "管理者ユーザーは、削除リンクが表示され、ユーザーを削除できる" do
      visit login_path
      fill_in 'Email', with: "user@example.com"
      fill_in 'Password', with: "foobar"
      click_button 'Log in'
      visit users_path
      expect(page).to have_link 'delete', href: user_path(another_user)
      expect(page).not_to have_link 'delete', href: user_path(user)
      expect {
        click_link 'delete'
      }.to change(User, :count).by(-1)
    end

    scenario "管理者ユーザーでなければ、削除リンクが表示されない" do
      visit login_path
      fill_in 'Email', with: "another@example.com"
      fill_in 'Password', with: "password"
      click_button 'Log in'
      visit users_path
      expect(page).not_to have_link 'delete'
    end
  end
end