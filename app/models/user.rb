require 'bcrypt'

class User < ActiveRecord::Base

  after_initialize do
    reset_session_token!
  end

  validates :user_name, :password_digest, :session_token, presence: true
  validates :session_token, uniqueness: true
  validates :user_name, uniqueness: { case_sensitive: false }

  def self.find_by_credentials(user_name, password)
    user = User.find_by_user_name(user_name)
    # User.find_by(user_name: user_name)

    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end


  def reset_session_token!
    self.session_token = SecureRandom.base64
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
end
