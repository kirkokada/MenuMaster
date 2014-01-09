shared_examples_for "visiting a protected page" do
  it { should have_title 'Sign in' }
end

shared_examples_for "submitting to a protected action" do
  specify { expect(response).to redirect_to signin_path }
end

shared_examples_for "submitting to a protected action as wrong user" do
  specify { expect(response).to redirect_to root_path }
end