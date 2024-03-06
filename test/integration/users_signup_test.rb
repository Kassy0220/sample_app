# frozen_string_literal: true

require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'invalid singup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: '',
                                         email: 'user@invalid',
                                         password: 'test',
                                         password_confirmation: 'te' } }
    end
    assert_response :unprocessable_entity
    assert_template 'users/new'
    assert_select 'li', '名前を入力してください'
    assert_select 'li', 'メールアドレスは不正な値です'
    assert_select 'li', 'パスワード(確認)とパスワードの入力が一致しません'
    assert_select 'li', 'パスワードは8文字以上で入力してください'
  end

  test 'valid signup information' do
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'Example User',
                                         email: 'user@example.com',
                                         password: 'testtest',
                                         password_confirmation: 'testtest' } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_select '.alert-success', 'Sample App へようこそ！'
    assert logged_in?
  end
end
