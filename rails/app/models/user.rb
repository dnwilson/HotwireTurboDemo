class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :notification_tokens

  before_create do
    self.access_token = SecureRandom.hex(10)
  end

  def remember_me
    (super == nil) ? '1' : super
  end
  
end
