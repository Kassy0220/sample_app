require 'rails_helper'

RSpec.feature "Micropost", type: :feature do
  let!(:user) { create(:user) }
  background do
    microposts = build_list(:serial_microposts, 30, created_at: Time.current, updated_at: Time.current, user: user)
    Micropost.insert_all microposts.map(&:attributes)
    feature_spec_log_in_as(user)
    visit root_path
  end
  
    feature "マイクロポストの投稿数が、正しく表示される" do
      context "複数の投稿をしているユーザーの場合" do
        scenario "投稿数が複数形で表示される" do
          expect(page).to have_content "#{user.microposts.count} microposts"
        end
      end

      context "一つだけ投稿をしているユーザーの場合" do
        scenario "投稿数が単数形で表示される" do
          click_on 'Log out'
          another_user = create(:another_user) 
          another_micropost = create(:micropost, user: another_user)
          feature_spec_log_in_as(another_user)         
          visit root_path
          expect(page).to have_content "1 micropost"
        end
      end

      context "全く投稿をしていないユーザーの場合" do
        scenario "投稿数が複数形で表示される" do
          click_on 'Log out'
          serial_user = create(:serial_user)  
          feature_spec_log_in_as(serial_user)          
          visit root_path
          expect(page).to have_content "0 microposts"
        end
      end
    end

  scenario "ホーム画面には、マイクロポストが分割して表示される" do
    expect(page).to have_selector '.pagination'
  end
  
  scenario "無効な値の場合は、マイクロポストが保存されない" do
    expect {
      fill_in 'micropost_content', with: ""
      click_button 'Post'
    }.to change(user.microposts, :count).by 0
    expect(page).to have_selector '#error_explanation'
  end

  scenario "有効な値の場合は、マイクロポストが保存される" do
    expect {
      fill_in 'micropost_content', with: "sample text"
      attach_file 'micropost_image', "#{Rails.root}/spec/files/avatar.png"
      click_button 'Post'
    }.to change(user.microposts, :count).by 1
    expect(page).to have_current_path(root_url)
    expect(page).to have_content 'sample text'
    expect(page).to have_selector "img[src$='avatar.png']"
  end

  scenario "削除リンクをクリックすると、マイクロポストを削除することができる" do
    expect(page).to have_link 'delete'
    expect {
      click_link 'delete', href: micropost_path(user.microposts.first)
    }.to change(user.microposts, :count).by -1
  end

  scenario "他のユーザーのマイクロポストには、削除リンクが表示されない" do
    another_user = create(:another_user)
    another_micropost = create(:micropost, user: another_user)
    visit user_path(another_user)
    expect(page).to have_content 'Test Text'
    expect(page).not_to have_link 'delete'
  end
end