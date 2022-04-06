module TestHelper
  def log_in_as(user, remember_me: '1')
    post login_path, params: { session: {
      email: user.email,
      password: user.password,
      remember_me: remember_me
    } }
  end

  def feature_spec_log_in_as(user) 
    visit login_path
    fill_in 'Email', with: "#{user.email}"
    fill_in 'Password', with: "foobar"
    click_button 'Log in'
  end
end