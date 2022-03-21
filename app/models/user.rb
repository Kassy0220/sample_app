class User < ApplicationRecord
  before_save { email.downcase! }
  has_one_attached :avatar
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  validates :avatar, content_type: ['image/png', 'image/jpg', 'image/jpeg'],
                     size: { less_than: 5.megabytes }
end
