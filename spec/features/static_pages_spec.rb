require 'rails_helper'

RSpec.feature "StaticPages", type: :feature do
  feature "static_pages have correct title" do
    given(:base_title) {'Ruby on Rails Tutorial Sample App'}

    scenario "静的ページのHome画面のタイトルが正しく表示される" do
      visit static_pages_home_url
      expect(page).to have_selector 'title', 
      text: "Home | #{base_title}", visible: false 
    end

    scenario "静的ページのHelp画面のタイトルが正しく表示される" do
      visit static_pages_help_url
      expect(page).to have_selector 'title', 
      text: "Help | #{base_title}", visible: false
    end

    scenario "静的ページのAbout画面のタイトルが正しく表示される" do
      visit static_pages_about_url
      expect(page).to have_selector 'title', 
      text: "About | #{base_title}", visible: false
    end

    scenario "静的ページのContact画面のタイトルが正しく表示される" do
      visit static_pages_contact_url
      expect(page).to have_selector 'title', 
      text: "Contact | #{base_title}", visible: false
    end    
  end
end
