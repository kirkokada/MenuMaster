require 'spec_helper'

describe "StaticPages" do
  
  subject { page }

  describe "Home page" do
  	before { visit '/static_pages/home' }
  	it { should have_selector 'h1', text: 'Invitor' }
  	it { should have_title 'Invitor' }
  end

  describe "Help page" do
  	before { visit "/static_pages/help" }
  	it { should have_selector 'h1', text: 'Help' }
  	it { should have_title 'Invitor | Help' }
  end

  describe "About page" do
  	before { visit "/static_pages/about"}
  	it { should have_selector 'h1', text: 'About' }
  	it { should have_title 'Invitor | About' }
  end
end
