class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  before_save :downcase_email
  before_create :create_activation_digest
  validates :name, :email, presence: true
  validates :name, length:
    {
      minimum: Settings.length.min_3,
      maximum: Settings.length.max_100
    }
  validates :email, uniqueness: true,
    length: {maximum: Settings.length.max_250},
    format: {with: URI::MailTo::EMAIL_REGEXP}
  has_secure_password
  validates :password, presence: true, length:
    {
      minimum: Settings.length.min_8,
      maximum: Settings.length.max_100
    }, allow_nil: true

  def self.digest string
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
    update_column :remember_digest, User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_column :remember_digest, nil
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
