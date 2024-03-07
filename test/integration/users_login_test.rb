# frozen_string_literal: true

require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'login with invalid information' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: '', password: '' } }

    assert_not logged_in?
    assert_response :unprocessable_entity
    assert_template 'sessions/new'
    assert_select '.alert-danger', 'メールアドレスとパスワードの組み合わせが正しくありません'
    get root_path
    assert_select '.alert-danger', count: 0
  end

  test 'login with valid email / invalid password' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: 'michael@example.com', password: 'invalid' } }

    assert_not logged_in?
    assert_response :unprocessable_entity
    assert_template 'sessions/new'
    assert_select '.alert-danger', 'メールアドレスとパスワードの組み合わせが正しくありません'
    get root_path
    assert_select '.alert-danger', count: 0
  end

  test 'login with valid information followed by logout' do
    post login_path, params: { session: { email: 'michael@example.com', password: 'testtest' } }

    assert logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)

    delete logout_path
    assert_not logged_in?
    assert_response :see_other
    assert_redirected_to root_url
    follow_redirect!
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0
  end
end
