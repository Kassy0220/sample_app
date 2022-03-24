require 'rails_helper'

RSpec.feature "Users", type: :feature do
  scenario "無効な値の場合は、ユーザー登録できない" do
    visit signup_path
    expect {
      fill_in 'Name', with: ""
      fill_in 'Email', with: "user@invalid"
      fill_in 'Password', with: "foo"
      fill_in 'Password confirmation', with: "bar"
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
      fill_in 'Password confirmation', with: "foobar"
      click_on 'Create my account'
    }.to change(User, :count).by(1)
    expect(page).to have_current_path(user_path(1))
    expect(page).to have_content 'Welcome to the Sample App!'
    expect(page).to have_selector("img[src$='avatar.png']")
  end
end