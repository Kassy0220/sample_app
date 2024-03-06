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
    assert_response :unprocessable_entity
    assert_template 'sessions/new'
    assert_select '.alert-danger', 'メールアドレスとパスワードの組み合わせが正しくありません'
    get root_path
    assert_select '.alert-danger', count: 0
  end

  test 'login with valid information' do
    post login_path, params: { session: { email: 'michael@example.com', password: 'testtest' } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)
  end
end
