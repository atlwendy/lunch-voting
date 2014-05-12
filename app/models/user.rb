class User < ActiveRecord::Base
  has_many :meeting_memberships
  has_many :meetings, through: :meeting_memberships
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates:email, presence: true, 
  					format: {with: VALID_EMAIL_REGEX },
  					uniqueness: { case_sensitive: false }
  before_save { self.email = email.downcase }

  has_secure_password
  validates :password, length: { minimum: 6 }
end
