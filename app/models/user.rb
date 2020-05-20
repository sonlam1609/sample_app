class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.reg.email
  USER_PARAMS = [:name, :email, :password, :password_confirmation].freeze
  before_save :email_down
  validates :name, presence: true, length: { maximum: Settings.reg.maxname }
  validates :email, format: { with: VALID_EMAIL_REGEX },
                             presence: true, uniqueness: true, length: { maximum: Settings.reg.maxemail }
  validates :password, presence: true, length: { minimum: Settings.reg.minipass }
  
  has_secure_password
  
  class << self
    def User.digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end
  end

  private
  
  def email_down 
    email.downcase!
  end
end
