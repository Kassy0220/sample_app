require 'rails_helper'

RSpec.feature "Relationship", type: :feature do
  let!(:user) { create(:user) }
  background do
    # userが10人をフォローし、10人からフォローされる
    create_relationships(user, 10)
    feature_spec_log_in_as(user)
  end

  scenario "Homeページとプロフィールページには、フォロー/フォロワー数が表示される" do
    visit root_path
    expect(page).to have_content "#{user.following.count} following"
    expect(page).to have_content "#{user.followers.count} followers"
    visit user_path(user)
    expect(page).to have_content "#{user.following.count} following"
    expect(page).to have_content "#{user.followers.count} followers"
  end

  scenario "フォローしているユーザーを表示するページで、人数が表示されている" do
    visit root_path
    click_on 'following'
    expect(page).to have_current_path(following_user_path(user))
    # ちゃんとフォローしているか確認
    expect(user.following).not_to be_empty
    expect(page).to have_content "#{user.following.count} following"
    user.following.each do |user|
      expect(page).to have_link "#{user.name}", href: user_path(user)
    end
  end

  scenario "フォロワーを表示するページで、人数が表示される" do
    visit root_path
    click_on 'followers'
    expect(page).to have_current_path(followers_user_path(user))
    # ちゃんとフォローされているか確認
    expect(user.followers).not_to be_empty
    expect(page).to have_content "#{user.followers.count} followers"
    user.followers.each do |user|
      expect(page).to have_link "#{user.name}", href: user_path(user)
    end
  end
end