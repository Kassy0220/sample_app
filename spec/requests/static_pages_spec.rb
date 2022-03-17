require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "static_pages responds successfully" do

    it "ルートページが表示される" do
      get root_path
      expect(response).to have_http_status(200)
    end
    
    it "静的ページのHelp画面が表示される" do
      get help_path
      expect(response).to have_http_status(200)
    end
    
    it "静的ページのAbout画面が表示される" do
      get about_path
      expect(response).to have_http_status(200)
    end

    it "静的ページのContact画面が表示される" do
      get contact_path
      expect(response).to have_http_status(200)
    end    
  end
end
