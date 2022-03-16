require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "static_pages responds successfully" do

    it "ルートページが表示される" do
      get root_url
      expect(response).to have_http_status(200)
    end

    it "静的ページのHome画面が表示される" do
      get static_pages_home_url
      expect(response).to have_http_status(200)
    end

    it "静的ページのHelp画面が表示される" do
      get static_pages_help_url
      expect(response).to have_http_status(200)
    end
    
    it "静的ページのAbout画面が表示される" do
      get static_pages_about_url
      expect(response).to have_http_status(200)
    end

    it "静的ページのContact画面が表示される" do
      get static_pages_contact_url
      expect(response).to have_http_status(200)
    end    
  end
end
