FactoryBot.define do
  factory :user, class: User do
    name {"Example User"}
    email {"user@example.com"}
    password {"foobar"}
    password_confirmation {"foobar"}
    admin {true}
    
    # 有効な画像
    trait :with_valid_avatar do
      avatar {Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/files/avatar.png'))}
    end
    # 無効な画像(許可されていないファイルタイプ)
    trait :with_invalid_filetype do
      avatar {Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/files/tako-ani03.gif'))}
    end
    # 無効な画像(ファイルサイズが大きすぎる)
    trait :with_invalid_filesize do
      avatar {Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/files/over7MB.jpeg'))}
    end
  end

  # 別のユーザー
  factory :another_user, class: User do
    name {"Example Another"}
    email {"another@example.com"}
    password {"password"}
    password_confirmation {"password"}
  end

  sequence :serial_name do |i|
    "Example User No.#{i + 1}"
  end

  sequence :serial_email do |i|
    "user-#{i + 1}@example.com"
  end

  factory :serial_user, class: User do
    name { generate :serial_name }
    email { generate :serial_email }
    password { "password" }
    password_confirmation { "password" }
  end
end