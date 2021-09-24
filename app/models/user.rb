class User < ApplicationRecord
  attr_accessor :remember_token
  validates :name, :email, :password, presence: true
  validates :name, length:
    {
      minimum: Settings.length.min_3,
      maximum: Settings.length.max_100
    }
  validates :password, length:
    {
      minimum: Settings.length.min_8,
      maximum: Settings.length.max_100
    }
  validates :email, uniqueness: true,
    length: {maximum: Settings.length.max_250},
    format: {with: URI::MailTo::EMAIL_REGEXP}
  has_secure_password

  def User.digest string
    cost =  if ActiveModel::SecurePassword.min_cost
              BCrypt::Engine::MIN_COST
            else
              BCrypt::Engine.cost
            end
    BCrypt::Password.create string, cost: cost
  end

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute :remember_digest, nil
  end
end
