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

		before { visit user_path(user) }

		it { should have_title user.username }
		it { should have_content user.username }
	end
end
