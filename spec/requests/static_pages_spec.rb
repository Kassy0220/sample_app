require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "#home" do
    it "ルートページが表示される" do
      get root_path
      expect(response).to have_http_status(200)
    end
  end
    
  describe "#help" do
    it "ヘルプページが表示される" do
      get help_path
      expect(response).to have_http_status(200)
    end
  end
    
  describe "about" do
    it "アバウトページが表示される" do
      get about_path
      expect(response).to have_http_status(200)
    end
  end

  describe "#contact" do
    it "コンタクトページが表示される" do
      get contact_path
      expect(response).to have_http_status(200)
    end    
  end
end
