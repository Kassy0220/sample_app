# frozen_string_literal: true

require 'test_helper'

class UsersLogin < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
end

class InvalidPasswordTest < UsersLogin
  test 'login path' do
    get login_path
    assert_template 'sessions/new'
  end

  test 'login with valid email / invalid password' do
    post login_path, params: { session: { email: 'michael@example.com', password: 'invalid' } }

    assert_not logged_in?
    assert_response :unprocessable_entity
    assert_template 'sessions/new'
    assert_select '.alert-danger', 'メールアドレスとパスワードの組み合わせが正しくありません'
    get root_path
    assert_select '.alert-danger', count: 0
  end
end

class ValidLogin < UsersLogin
  def setup
    super
    post login_path, params: { session: { email: 'michael@example.com', password: 'testtest' } }
  end
end

class ValidLoginTest < ValidLogin
  test 'valid login' do
    assert logged_in?
    assert_redirected_to @user
  end

  test 'redirect after login' do
    follow_redirect!
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)
  end
end

class Logout < ValidLogin
  def setup
    super
    delete logout_path
  end
end

class LogoutTest < Logout
  test 'succesful logout' do
    assert_not logged_in?
    assert_response :see_other
    assert_redirected_to root_url
  end

  test 'redirect after logout' do
    follow_redirect!
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0
  end
end
