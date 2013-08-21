require 'spec_helper'

describe "UserPages" do

	subject { page }

	describe "signup" do
		before { visit signup_path }

		let(:submit) { "Create account" }

		describe "page" do
			
			it { should have_content 'Sign up' }
			it { should have_title full_title('Sign up') }

		end

		describe "with invalid information" do
			
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end

			describe "after submission" do
				
				before { click_button submit }

				it { should have_selector "div.alert-error" }
			end

		end

		describe "with valid information" do

			let(:username) { "username" }

			before do
			  fill_in "Username",     with: username
			  fill_in "Email",        with: "em@il.com"
			  fill_in "Password",     with: "password"
			  fill_in "Confirmation", with: "password"
			end

			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end

			describe "after submission" do
				
				before { click_button submit }

				it { should have_title username }
				it { should have_selector "div.alert.alert-success" }
				it { should     have_link "Sign out", href: signout_path }
				it { should_not have_link "Sign in",  href: signin_path }

			end
		end
	end

	describe "profile page" do
		
		let(:user) { FactoryGirl.create(:user) }
		let!(:m1) { FactoryGirl.create :micropost, user: user }
		let!(:m2) { FactoryGirl.create :micropost, user: user }

		before { visit user_path(user) }

		it { should have_title user.username }
		it { should have_content user.username }

		describe "microposts" do
			it { should have_content m1.content }
			it { should have_content m2.content }
			it { should have_content user.microposts.count }
			it { should_not have_link "delete", href: micropost_path(m1) }
			it { should_not have_link "delete", href: micropost_path(m2) }

			describe "after signing in" do
				before { sign_in user }

				it { should have_link "delete", href: micropost_path(m1) }
				it { should have_link "delete", href: micropost_path(m2) }
			end
		end

		describe "follow/unfollow buttons" do
			let(:other_user) { FactoryGirl.create(:user) }
			before { sign_in user }

			describe "following a user" do
				before { visit user_path(other_user) }

				it "should incremet the followed user count" do
					expect do
						click_button "Follow"
					end.to change(user.followed_users, :count).by(1)
				end

				it "should increment the other user's followers count" do
					expect do
						click_button "Follow"
					end.to change(other_user.followers, :count).by(1)
				end

				describe "toggling the button" do
					before { click_button "Follow" }
					it { should have_xpath("//input[@value='Unfollow']") }
				end
			end

			describe "unfollowing a user" do
				before do
					user.follow!(other_user)
					visit user_path(other_user)
				end

				it "should decrement the followed users count" do
					expect do
						click_button "Unfollow"
					end.to change(user.followed_users, :count).by(-1)
				end

				it "should decrement the other users's followers count" do
					expect do
						click_button "Unfollow"
					end.to change(other_user.followers, :count).by(-1)
				end

				describe "toggling the button" do
					before { click_button "Unfollow" }
					it { should have_xpath("//input[@value='Follow']") }
				end
			end
		end
	end

	describe "edit" do
		let(:user) { FactoryGirl.create(:user) }
		before do 
			sign_in user
			visit edit_user_path(user)
		end

		describe "page" do
			it { should have_title "Edit user" }
			it { should have_content "Update your profile" }
			it { should have_link 'change', href: 'http://gravatar.com/emails' }
		end

		describe "with invalid information" do
			before { click_button "Update" }

			it { should have_selector 'div.alert.alert-error' }
		end

		describe "with valid information" do
			let(:new_name) { "New_name" }
			let(:new_email) { "new@email.com" }

			before do
				fill_in "Username",     with: new_name
				fill_in "Email",        with: new_email
				fill_in "Password",     with: user.password
				fill_in "Confirmation", with: user.password
				click_button "Update"
			end

			it { should have_title new_name.downcase }
			it { should have_selector 'div.alert.alert-success' }
			it { should have_link 'Sign out' }
			specify { expect(user.reload.username).to eq new_name.downcase }
			specify { expect(user.reload.email).to eq new_email.downcase }
		end

		describe "forbidden attributes" do
			let(:params) do
				{ user: { admin: true, password: user.password, 
					      password_confirmation: user.password } }
			end
			before { patch user_path(user), params }
			specify { expect(user.reload).not_to be_admin }
		end
	end

	describe "index" do
		let!(:user)  { FactoryGirl.create :user }
		let!(:admin) { FactoryGirl.create :admin }
		before(:each) do
			sign_in admin
			visit users_path
		end

		it { should have_title 'All users' }
		it { should have_content 'All users' }
		it { should have_link 'delete' }

		it "should list all users" do
			User.all.each do |user|
				expect(page).to have_selector 'li', text: user.username
			end
		end

		describe "pagination" do
			before(:all) { 30.times { FactoryGirl.create :user } }
			after(:all) { User.delete_all }

			it { should have_selector 'div.pagination' }

			it "should list each user" do
				User.paginate(page: 1).each do |user|
					expect(page).to have_selector 'li', text: user.username
				end
			end
		end

		describe "delete links as an admin" do
			before do
			  sign_in admin
			  visit users_path
			end

			it { should have_link 'delete', href: user_path(user) }
			it "should be able to delete user" do
				expect { click_link 'delete' }.to change(User, :count).by(-1)
			end
			it { should_not have_link 'delete', href: user_path(admin) }
		end
	end

	describe "following/followers" do
		let(:user) { FactoryGirl.create(:user)}
		let(:other_user) { FactoryGirl.create(:user) }
		before { user.follow!(other_user) }

		describe "followed users" do
			before do
			  sign_in user
			  visit following_user_path(user)
			end

			it { should have_title(full_title('Following')) }
			it { should have_selector('h3', text: 'Following') }
			it { should have_link(other_user.username, href: user_path(other_user)) }
		end

		describe "followers" do
			before do
			  sign_in other_user
			  visit followers_user_path(other_user)
			end

			it { should have_title(full_title('Followers')) }
			it { should have_selector('h3', text: 'Followers') }
			it { should have_link(user.username, href: user_path(user)) }
		end
	end
end
