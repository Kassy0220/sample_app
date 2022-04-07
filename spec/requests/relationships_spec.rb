require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  describe "#create" do
    it "非ログイン状態でフォローしようとすると、リダイレクトされる" do
      expect{
        post relationships_path
      }.to change(Relationship, :count).by(0)
      expect(response).to redirect_to login_url
    end
  end

  describe "#destroy" do
    it "非ログイン状態でフォロー解除しようとすると、リダイレクトされる" do
      user = create(:user)
      create_relationships(user, 1)
      expect{
        delete relationship_path(Relationship.first)
      }.to change(Relationship, :count).by(0)
      expect(response).to redirect_to login_url
    end
  end
end
