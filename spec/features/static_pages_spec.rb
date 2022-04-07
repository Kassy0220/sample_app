require 'rails_helper'

RSpec.feature "StaticPages", type: :feature do
  feature "static_pages have correct title" do
    scenario "Home画面のタイトルが正しく表示される" do
      visit root_path
      expect(page).to have_title full_title()
      expect(page).not_to have_title full_title("Home")
    end

    scenario "Help画面のタイトルが正しく表示される" do
      visit help_path
      expect(page).to have_title full_title("Help")
    end

    scenario "About画面のタイトルが正しく表示される" do
      visit about_path
      expect(page).to have_title full_title("About")
    end

    scenario "Contact画面のタイトルが正しく表示される" do
      visit contact_path
      expect(page).to have_title full_title("Contact")
    end   

    scenario "Signup画面のタイトルが正しく表示される" do
      visit signup_path
      expect(page).to have_title full_title("Sign up")
    end   
  end

  feature "static_pages have correct link" do
    context "have correct link" do
      scenario "非ログインの時、Home画面に各ページへのリンクが表示されている" do
        visit root_path
        expect(page).to have_link 'Home', href: root_path
        expect(page).to have_link 'sample app', href: root_path
        expect(page).to have_link 'Help', href: help_path
        expect(page).to have_link 'Log in', href: login_path
        expect(page).to have_link 'About', href: about_path
        expect(page).to have_link 'Contact', href: contact_path
        expect(page).to have_link 'Sign up now!', href: signup_path
        visit contact_path
        expect(page).to have_title full_title("Contact")
      end    

      scenario "ログイン済みの時、Home画面に各ページへのリンクが表示されている" do
        user = create(:user)
        feature_spec_log_in_as(user)
        expect(page).to have_link 'Users', href: users_path	
        expect(page).to have_link 'Profile', href: user_path(user)
        expect(page).to have_link 'Settings', href: edit_user_path(user)
        expect(page).to have_link 'Log out', href: logout_path
      end    
    end

    context "feed" do
      let!(:user) { create(:user) }
      background do
        create_microposts(user, 5)
        another_user = create(:another_user)
        create_microposts(another_user, 5)
        user.follow(another_user)
        feature_spec_log_in_as(user)
        visit root_path
      end
      scenario "フィードが正しく表示される" do
        user.feed.page(1).each do |micropost|
          expect(page).to have_content micropost.content
        end
      end
    end
  end
end
