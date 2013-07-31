require 'spec_helper'

describe "AuthenticationPages" do
  
  subject { page }
	
  let(:user) { FactoryGirl.create(:user) }

  describe "sign in" do

    before { visit signin_path }
    
    describe "page" do  

      it { should have_selector 'h1', text: "Sign in" }
      it { should have_title "Sign in" }

    end

    describe "with invalid information" do
      
      before { click_button "Sign in" }

      it { should have_title "Sign in" }
      it { should have_selector "div.alert.alert-error", text: "Invalid" }

    end

    describe "with valid information" do
      

  		before { sign_in user }


  		it { should have_title user.username }
      it { should have_link 'Users',       href: users_path }
  		it { should have_link 'Profile',     href: user_path(user) }
      it { should have_link 'Settings',    href: edit_user_path(user) }
  		it { should have_link 'Sign out',    href: signout_path }
  		it { should_not have_link 'Sign in', href: signin_path }
  		
      describe "followed by sign out" do
        before { click_link "Sign out" }

        it { should have_link 'Sign in', href: signin_path }
      end
  	end
  end

  describe "authorization" do
    
    describe "for signed in users" do
      let(:user) { FactoryGirl.create :user }

      describe "visiting the sign up page" do
        before do 
          sign_in user
          visit signup_path
        end

        it { should_not have_title 'Sign up' }
      end

      describe "submitting to the Users#create action" do
        before do
          sign_in user, no_capybara: true
          post users_path
        end

        specify { expect(response).to redirect_to root_path }
      end
    end

    describe "for non-signed in users" do
        
      describe "visiting a protected page" do
        
        before { visit edit_user_path(user) }

        it { should have_title 'Sign in' }

        describe "after signing in" do
          before do
            fill_in "Username", with: user.username
            fill_in "Password", with: user.password
            click_button "Sign in"
          end

          it "should redirect to the desired page" do
            expect(page).to have_title full_title('Edit user')
          end

          describe "when signing in again" do
            before do
              delete signout_path
              sign_in user
            end

            it "should render the default page" do
              expect(page).to have_title user.username
            end
          end
        end
      end

      describe "visiting the Users#index page" do
        before { visit users_path }
        it { should have_title 'Sign in' }
      end

      describe "submitting to the update action" do
        
        before { patch user_path(user) }

        specify { expect(response).to redirect_to(signin_path) }
      end

      describe "in the Microposts controller" do
        
        describe "submitting to the create action" do
          before { post microposts_path }
          specify { expect(response).to redirect_to signin_path }
        end

        describe "submitting to the destroy action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { expect(response).to redirect_to signin_path }
        end
      end
    end

    describe "for wrong user" do
      let(:wrong_user) { FactoryGirl.create :user }

      describe "visiting Users#edit page" do
        before do
          sign_in user 
          visit edit_user_path(wrong_user)
        end

        it { should_not have_title full_title('Edit user') }
        it { should_not have_title full_title('Sign in') }
      end

      describe "submitting a PATCH request to the Users#update action" do
        before do 
          sign_in user, no_capybara: true 
          patch user_path(wrong_user)
        end
        specify { expect(response).to redirect_to(root_path) }
      end
    end

    describe "for non-admin users" do
      let(:user) { FactoryGirl.create :user }
      let(:non_admin) { FactoryGirl.create :user }

      before { sign_in non_admin, no_capybara: true }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end
  end
end
