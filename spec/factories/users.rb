FactoryBot.define do
  factory :user do
    name {"Example User"}
    email {"user@example.com"}
    password {"foobar"}
    password_confirmation {"foobar"}

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
end