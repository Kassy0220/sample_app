require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "user_page responds successfully" do
    it "returns http success" do
      get signup_path
      expect(response).to have_http_status(200)
    end
  end

end
