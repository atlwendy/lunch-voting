class User < ActiveRecord::Base
  has_many :meeting_memberships
  has_many :meetings, through: :meeting_memberships
  belongs_to :invitation

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates:email, presence: true, 
  					format: {with: VALID_EMAIL_REGEX },
  					uniqueness: { case_sensitive: false }
  before_save { self.email = email.downcase }
  #before_create :create_remember_token
  before_create {generate_token(:remember_token)}
  
  has_secure_password
  #validates :password, length: { minimum: 6 }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def invitation_token
    invitation.token if invitation
  end

  def invitation_token=(token)
    self.invitation = Invitation.find_by_token(token)
  end

  def self.allbuddies(user)
    buddies = []
    User.all.order('username').each{|x| buddies.push(x) if not (x.meetings & user.meetings).empty?}
    buddies = buddies - [user] if not buddies.empty?
  end

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end

end
