require 'spec_helper'

feature "user signs in" do 
  scenario "with valid email and password" do 
    user = Fabricate(:user)
    sign_in user
    expect(page).to have_content user.username
  end
end