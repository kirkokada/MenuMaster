require 'spec_helper'

describe "MicropostPages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	before { sign_in user }

	describe "micropost creation" do
		before { visit root_path }

		describe "with invalid information" do
			
			it "should not create a micropost" do
				expect { click_button "Post" }.not_to change(Micropost, :count)
			end

			describe "error messages" do
				before { click_button "Post" }
				it { should have_selector "div.alert.alert-error" }
			end
		end

		describe "with valid information" do
			before { fill_in "micropost_content", with: "Lorem ipsum" }
			it "should create a micropost" do
				expect { click_button "Post" }.to change(Micropost, :count).by(1)
			end
		end
	end

	describe "micropost destruction" do
		before { FactoryGirl.create :micropost, user: user }
		
		describe "as correct user" do
			before { visit newsfeed_path }

			it "should delete the micropost" do
				expect { click_link "delete" }.to change(Micropost, :count).by(-1)
			end
		end
	end

	describe "newsfeed" do
		before do 
			2.times { FactoryGirl.create :micropost, user: user }
			sign_in user
			click_link "Newsfeed"
		end

		it "should render the user's feed" do
		  user.feed.each do |item|
		    expect(page).to have_selector("li##{item.id}", text: item.content)
		  end
		end
	end
end
