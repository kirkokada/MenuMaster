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
