class User < ApplicationRecord
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

  def self.digest string
    cost =  if ActiveModel::SecurePassword.min_cost
              BCrypt::Engine::MIN_COST
            else
              BCrypt::Engine.cost
            end
    BCrypt::Password.create string, cost: cost
  end
end
