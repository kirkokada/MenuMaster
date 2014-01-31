require 'spec_helper'

describe "StaticPages" do
  
  subject { page }

  shared_examples_for "all static pages" do
    it { should have_content heading }
    it { should have_title full_title(title) }
  end

  describe "Home page" do
  	before { visit root_path }
    let(:heading) { "MenuMaster" }
    let(:title) { "" }

  	it_should_behave_like "all static pages"

    describe "navbar and footer links" do
      
      it "should go to the right pages" do
        click_link 'Help'
        page.should have_title full_title('Help')
        click_link 'About'
        page.should have_title full_title('About')
        click_link 'MenuMaster'
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
        sign_in user
        visit root_path
      end

      describe "links" do
        
        it { should have_link "Recipes",  href: home_recipe_nav_path }
        it { should have_link "Track", href: new_user_meal_path(user) }
        it { should have_link "Newsfeed", href: newsfeed_path }
      end

      describe "recipes links" do
        before { click_link "Recipes" }

        it { should have_link "My Recipes", href: recipes_path }
        it { should have_link "Browse", href: browse_recipes_path }
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
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
