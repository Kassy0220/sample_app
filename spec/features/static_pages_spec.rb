require 'rails_helper'

RSpec.feature "StaticPages", type: :feature do
  feature "static_pages have correct title" do

    scenario "Home画面のタイトルが正しく表示される" do
      visit root_path
      expect(page).to have_selector 'title', 
      text: full_title(), visible: false 
      expect(page).not_to have_selector 'title', 
      text: full_title("Home"), visible: false
    end

    scenario "Help画面のタイトルが正しく表示される" do
      visit help_path
      expect(page).to have_selector 'title', 
      text: full_title("Help"), visible: false
    end

    scenario "About画面のタイトルが正しく表示される" do
      visit about_path
      expect(page).to have_selector 'title', 
      text: full_title("About"), visible: false
    end

    scenario "Contact画面のタイトルが正しく表示される" do
      visit contact_path
      expect(page).to have_selector 'title', 
      text: full_title("Contact"), visible: false
    end   

    scenario "Signup画面のタイトルが正しく表示される" do
      visit signup_path
      expect(page).to have_selector 'title', 
      text: full_title("Sign up"), visible: false
    end   

    scenario "Home画面に各ページへのリンクが表示されている" do
      visit root_path
      expect(page).to have_link 'Home', href: root_path
      expect(page).to have_link 'sample app', href: root_path
      expect(page).to have_link 'Help', href: help_path
      expect(page).to have_link 'About', href: about_path
      expect(page).to have_link 'Contact', href: contact_path
      expect(page).to have_link 'Sign up now!', href: signup_path
      visit contact_path
      expect(page).to have_selector 'title', 
      text: full_title("Contact"), visible: false
    end    
  end
end
