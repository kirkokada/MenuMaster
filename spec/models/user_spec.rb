require 'spec_helper'

describe User do
	let(:user) { User.new(username: "Username", email: "e@mail.com", password: "password", 
			  	               password_confirmation: "password") } 
	subject { user }

	it { should respond_to :admin }
	it { should respond_to :authenticate }
	it { should respond_to :email }
	it { should respond_to :followed_users }
	it { should respond_to :followers }
	it { should respond_to :following? }
	it { should respond_to :follow! }
	it { should respond_to :microposts }
	it { should respond_to :password_digest }
	it { should respond_to :password }
	it { should respond_to :password_confirmation }
	it { should respond_to :remember_token }
	it { should respond_to :username }
	it { should respond_to :relationships }
	it { should respond_to :reverse_relationships }

	describe "when admin is set to true" do
		before do
		  user.save!
		  user.toggle!(:admin)
		end

		it { should be_admin }
	end

	describe "when username" do

		describe "is not present" do
			before { user.username = " " }
			it { should_not be_valid }
		end

		describe "is too long" do
			before { user.username = 'a' * 26 }
			it { should_not be_valid }
		end

		describe "is not unique" do
			let(:user_with_same_username) { user.dup }
			before do
			  user_with_same_username.username = user.username.upcase
			  user_with_same_username.email = "other@email.com"
			  user_with_same_username.save
			end

			it { should_not be_valid }
		end

		describe "is mixed case" do
			let(:mixed_case_username) { "UsErNaMe" }

			it "should be saved as lower case" do
				user.username = mixed_case_username
				user.save
				expect(user.reload.username).to eq mixed_case_username.downcase
			end
		end

		describe "format is invalid" do
			it "should be invalid" do
				usernames = %w[!nvalid in.valid inv@lid]
				usernames.each do |username|
					user.username = username
					user.should_not be_valid
				end
			end
		end

		describe "format is valid" do
			usernames = %w[validname val_idname val_1dname]
			it "should be valid" do
				usernames.each do |username|
					user.username = username
					expect(user).to be_valid
				end
			end
		end
	end 

	describe "when email" do
		
		describe "is not present" do
			before { user.email = " "}
			it { should_not be_valid }
		end

		describe "format is not valid" do
			addresses = %w[!nvalid@email.com invalid@email..com invalid@email,com invalidemail.com invalid@email.]
			it "should be invalid" do
				addresses.each do |address|
					user.email = address
					expect(user).not_to be_valid
				end
			end
		end

		describe "format is valid" do
			addresses = %w[va+lid@email.com valid@email.ne.jp val.1d@email.ne.co.jp]
			it "should be valid" do
				addresses.each do |address|
					user.email = address
					expect(user).to be_valid
				end
			end
		end

		describe "is not unique" do
			let(:user_with_same_email) { user.dup }
			before do
			  user_with_same_email.email = user.email.upcase
			  user_with_same_email.username = "different_username"
			  user_with_same_email.save
			end

			it { should_not be_valid }
		end

		describe "is mixed case" do
			let(:mixed_case_email) { "EmAiL@email.COM" }

			it "should be saved as lower case" do
				user.email = mixed_case_email
				user.save
				expect(user.reload.email).to eq mixed_case_email.downcase
			end
		end
	end

	describe "when password" do
		
		describe "is not present" do
			let(:user) { User.new(username: "Username", email: "e@mail.com", password: " ", 
			  	               password_confirmation: " ") }

			it { should_not be_valid }
		end

		describe "doesn't match confirmation" do
		  let(:user) { User.new(username: "Username", email: "e@mail.com", password: "mismatch", 
			  	               password_confirmation: "ohno") }

			it { should_not be_valid }
		end

		describe "confirmation is nil" do
			let(:user) { User.new(username: "Username", email: "e@mail.com", password: "password", 
			  	               password_confirmation: nil) }

			it { should_not be_valid }
		end

		describe "is too short" do
			let(:user) { User.new(username: "Username", email: "e@mail.com", password: "short", 
			  	               password_confirmation: "short") }

			it { should_not be_valid }
		end
	end

	describe "return value of authentication method" do
		before { user.save }
		let(:found_user) { User.find_by email: user.email }

		describe "with valid password" do
			it { should eq found_user.authenticate(user.password) }
		end

		describe "with invalid password" do
			let(:user_for_invalid_password) { found_user.authenticate("invalid") }

			it { should_not eq user_for_invalid_password }
			specify { expect(user_for_invalid_password).to be_false }
		end
	end

	describe "its remember token" do
		before { user.save }

		its(:remember_token) { should_not be_blank }
	end

	describe "micropost associations" do
		before { user.save }
		let!(:older_micropost) { FactoryGirl.create :micropost, user: user, created_at: 1.day.ago }
		let!(:newer_micropost) { FactoryGirl.create :micropost, user: user, created_at: 1.hour.ago }

		it "should have the microposts in the correct order" do
			expect(user.microposts).to eq [newer_micropost, older_micropost]
		end

		it "should destroy associated microposts" do
			microposts = user.microposts.to_a
			user.destroy
			expect(microposts).not_to be_empty
			microposts.each do |micropost|
				expect(Micropost.where(id: micropost.id)).to be_empty
			end
		end

		describe "status" do
			let(:unfollowed_post) do 
				FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
			end
			let(:followed_user) { FactoryGirl.create(:user) }

			before do
			  user.follow!(followed_user)
			  3.times { followed_user.microposts.create!(content: "Lorem ipsum") }
			end

			its(:feed) { should include(older_micropost) }
			its(:feed) { should include(newer_micropost) }
			its(:feed) { should_not include(unfollowed_post) }
			its(:feed) do 
				followed_user.microposts.each do |micropost|
					should include(micropost)
				end
			end
		end
	end

	describe "folowing" do
		let(:other_user) { FactoryGirl.create(:user) }
		before do
			user.save
			user.follow!(other_user)
		end

		it { should be_following other_user }
		its(:followed_users) { should include other_user }

		describe "followed user" do
			subject { other_user }
			its(:followers) { should include user }
		end

		describe "and unfollowing" do
			before { user.unfollow!(other_user) }

			it { should_not be_following other_user }
			its(:followed_users) { should_not include other_user }
		end
	end
end
