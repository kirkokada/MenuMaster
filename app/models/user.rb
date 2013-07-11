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

	before_create { create_token(:remember_token) }

	def User.new_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	private

		def create_token(column)
			begin
				self[column] = User.encrypt(User.new_token)
			end while User.exists?(column => self[column])
		end
end
