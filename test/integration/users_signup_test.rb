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
    assert_select 'li', "Name can't be blank"
    assert_select 'li', 'Email is invalid'
    assert_select 'li', "Password confirmation doesn't match Password"
    assert_select 'li', 'Password is too short (minimum is 8 characters)'
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
    assert_select '.alert-success', 'Welcome to the Sample App!'
  end
end
