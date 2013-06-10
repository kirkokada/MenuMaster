require 'spec_helper'

describe "UserPages" do

	subject { page }

	describe "signup" do
		before { visit signup_path }

		describe "page" do
			
			it { should have_content 'Sign up' }
			it { should have_title 'Sign up' }
		end
	end
end
