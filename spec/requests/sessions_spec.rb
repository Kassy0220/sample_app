require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "login_page responds successfully" do
    it "ログインページが表示される" do
      get login_path
      expect(response).to have_http_status(200)
    end
  end
end
