class Rack::Test::CookieJar
  # RSpecでcookies.signedがエラーになる対処
  def signed
    self
  end

  def permanent
    self
  end

  def encrypted
    self
  end
end