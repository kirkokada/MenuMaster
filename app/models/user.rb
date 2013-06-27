class User < ActiveRecord::Base
	VALID_USERNAME_REGEX = /\A[\w]+\z/i 
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

	validates :username, presence: true, length: { maximum: 25 }, 
	                     format: { with: VALID_USERNAME_REGEX }, uniqueness: { case_sensitive: false }
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	validates :password, length: { minimum: 6 }
	validates :password_confirmation, presence: true

	has_secure_password

	before_save do
		self.email = email.downcase
		self.username = username.downcase 
	end

end
