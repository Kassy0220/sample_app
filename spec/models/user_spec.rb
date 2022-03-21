require 'rails_helper'

RSpec.describe User, type: :model do
  it "正しい値であれば、モデルは有効になる" do
    user = build(:user, :with_valid_avatar)
    expect(user).to be_valid
  end  

  it "名前が存在していなければ、モデルは無効になる" do
    user = build(:user, name: "")
    expect(user).not_to be_valid 
  end

  it "メールアドレスが存在していなければ、モデルは無効になる" do
    user = build(:user, email: "")
    expect(user).not_to be_valid
  end

  it "名前が51文字以上であれば、モデルは無効になる" do
    user = build(:user, name: "a" * 51)
    expect(user).not_to be_valid
  end

  it "メールアドレスが256文字以上であれば、モデルは無効になる" do
    user = build(:user, email: "a" * 244 + "@example.com")
    expect(user).not_to be_valid
  end

  it "有効なメールアドレスであれば、モデルは有効になる" do
    valid_address = %w[user@example.com User@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_address.each do |valid_address|
      user = build(:user, email: valid_address)
      expect(user).to be_valid
    end
  end

  it "無効なメールアドレスであれば、モデルは無効になる" do
    invalid_address = %w[user@example,com user_at_foo.org user.name@example.
    foo@bar_baz.com foo@bar+baz.com, foo@bar..com]
    invalid_address.each do |invalid_address|
      user = build(:user, email: invalid_address)
      expect(user).not_to be_valid
    end
  end

  it "重複したメールアドレスであれば、モデルは無効になる" do
    user = build(:user)
    duplicate_user = user.dup
    duplicate_user.email = user.email.upcase
    user.save
    expect(duplicate_user).not_to be_valid
  end

  it "メールアドレスは、小文字で保存される" do
    mixed_case_email = "Foo@ExAmPle.COM"
    user = create(:user, email: mixed_case_email)
    expect(user.email).to eq "foo@example.com"
  end

  it "パスワードが存在していなければ、モデルは無効になる"  do
    user = build(:user, password: "", password_confirmation: "")
    expect(user).not_to be_valid
  end

  it "パスワードが6文字以上でなければ、モデルは無効になる" do
    user = build(:user, password: "12345", password_confirmation: "12345")
    expect(user).not_to be_valid
  end

  it "許可されていないファイルタイプであれば、モデルは無効になる" do
    user = build(:user, :with_invalid_filetype)
    expect(user).not_to be_valid
  end

  it "5MB以上のファイルサイズであれば、モデルは無効になる" do
    user = build(:user, :with_invalid_filesize)
    expect(user).not_to be_valid
  end
end
