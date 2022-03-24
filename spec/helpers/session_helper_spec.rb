require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  describe 'current_userメソッドのテスト' do
    let(:user) { create(:user) }
    before do
      # cookieに値を保存
      remember(user)
    end
    it 'sessionの値が空でも、ユーザーを返す' do
      expect(user).to eq current_user
      expect(logged_in?).to be_truthy
    end  

    it 'remember_digestの値が異なると、ユーザーを返さない' do
      user.update_attribute(:remember_digest, User.digest(User.new_token))
      expect(current_user).to eq nil
    end
  end
end