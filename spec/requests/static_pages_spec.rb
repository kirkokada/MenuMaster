require 'spec_helper'

describe "StaticPages" do
  
  subject { page }

  shared_examples_for "all static pages" do
    it { should have_content heading }
    it { should have_title full_title(title) }
  end

  describe "Home page" do
  	before { visit root_path }
    let(:heading) { "Invitor" }
    let(:title) { "" }

  	it_should_behave_like "all static pages"

    describe "navbar and footer links" do
      
      it "should go to the right pages" do
        click_link 'Help'
        page.should have_title full_title('Help')
        click_link 'About'
        page.should have_title full_title('About')
        click_link 'Invitor'
        page.should have_title full_title('')
        click_link 'Contact'
        page.should have_title full_title('Contact')
        click_link 'Home'
        page.should have_title full_title('')
        click_link 'Sign up'
        page.should have_title full_title('Sign up')
      end
    end

    describe "for signed in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        2.times { FactoryGirl.create(:micropost, user: user) }
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end
    end
  end

  describe "Help page" do
  	before { visit help_path }
  	let(:heading) { "Help" }
    let(:title) { "Help" }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
  	before { visit about_path }
  	let(:heading) { "About" }
    let(:title) { "About" }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading) { "Contact" }
    let(:title) { "Contact" }

    it_should_behave_like "all static pages"
  end
end
