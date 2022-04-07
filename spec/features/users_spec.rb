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

    scenario "有効な値の場合は、ユーザー登録される" do
      visit signup_path
      expect {
        fill_in 'Name', with: "Example User"
        fill_in 'Email', with: "user@example.com"
        attach_file "Avatar", "#{Rails.root}/spec/files/avatar.png"
        fill_in 'Password', with: "foobar"
        fill_in 'Confirmation', with: "foobar"
        click_on 'Create my account'
      }.to change(User, :count).by(1)
      # メールアドレスによるアカウント有効化の手順はスキップ
      user = User.last
      user.toggle!(:activated)
      visit  user_path(user)
      expect(page).to have_selector("img[src$='avatar.png']")
    end
  end

  feature "#index" do
    given!(:user) { create(:user) }
    background do
      users = build_list(:serial_user, 30, created_at: Time.current,      updated_at: Time.current)
      User.insert_all users.map(&:attributes)
    end
    scenario "ログイン済みのユーザーはユーザー一覧ページが表示される" do
      feature_spec_log_in_as(user)
      visit users_path
      expect(page).to have_current_path users_path
      expect(page.all('.pagination').count).to eq 2
      User.all.page(1).each do |user|
        expect(page).to have_link "#{user.name}"
      end
    end
  end

  feature "#show" do
  let!(:user) { create(:user) }
  background do
    microposts = build_list(:serial_microposts, 30, created_at: Time.current, updated_at: Time.current, user: user)
    Micropost.insert_all microposts.map(&:attributes)
    feature_spec_log_in_as(user)
  end
    scenario "ユーザーのプロフィール画面には、投稿が表示される" do
      expect(page).to have_current_path user_path(user)
      expect(page).to have_content "Microposts (#{user.microposts.count})"
      expect(page.all('.pagination').count).to eq 1
      user.microposts.page(1).each do |micropost|
        expect(page).to have_content micropost.content
      end
    end
  end

  feature "#update" do
    given!(:user) { create(:user, :with_valid_avatar) }
    scenario "ユーザー画像を更新すると、新しい画像が表示される" do
      feature_spec_log_in_as(user)
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
      fill_in 'Password', with: "foobar"
      click_button 'Log in'
      visit users_path
      expect(page).not_to have_link 'delete'
    end
  end

  feature "#following" do
    let!(:user) { create(:user) }
    let!(:another_user) { create(:another_user) }
    background do
      feature_spec_log_in_as(user)
      visit user_path(another_user)
    end

    scenario "他のユーザーをフォロー/フォロー解除ができる(非同期)", js: true  do
      expect(page).to have_button 'Follow'
      # ユーザーをフォロー
      expect {
        click_on 'Follow'
        sleep 0.5
      }.to change(Relationship, :count).by(1) 
      expect(page).to have_link "#{another_user.followers.count} followers"
      expect(page).to have_button 'Unfollow'
      # ユーザーをフォロー解除
      expect {
          click_on 'Unfollow'
          sleep 0.5
        }.to change(Relationship, :count).by(-1)
      expect(page).to have_link "#{another_user.followers.count} followers"
      expect(page).to have_button 'Follow'
    end
  end
end