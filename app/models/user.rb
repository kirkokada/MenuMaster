# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string(255)
#  email           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#

class User < ActiveRecord::Base
	VALID_USERNAME_REGEX = /\A[\w]+\z/i 
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

	validates :username, presence: true, length: { maximum: 25 }, 
	                     format: { with: VALID_USERNAME_REGEX }, uniqueness: { case_sensitive: false }
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	validates :password, length: { minimum: 6 }
	validates :password_confirmation, presence: true

	has_secure_password

	has_many :followed_users, through: :relationships, source: :followed
	has_many :followers, through: :reverse_relationships, source: :follower
	has_many :microposts, dependent: :destroy
	has_many :recipes, dependent: :destroy
	has_many :reverse_relationships, foreign_key: "followed_id", 
																	 class_name: "Relationship", 
																	 dependent: :destroy
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :meals, dependent: :destroy

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

	def feed
		Micropost.from_users_followed_by(self)
	end

	def following?(other_user)
		self.relationships.find_by(followed_id: other_user.id)
	end

	def follow!(other_user)
		self.relationships.create!(followed_id: other_user.id)
	end

	def unfollow!(other_user)
		self.relationships.find_by(followed_id: other_user.id).destroy!
	end

	def to_param
		self.username
	end

	private

		def create_token(column)
			begin
				self[column] = User.encrypt(User.new_token)
			end while User.exists?(column => self[column])
		end
end
