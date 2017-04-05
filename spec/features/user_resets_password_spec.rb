require 'spec_helper'

feature "User resets password" do 
  scenario "user successfully resets password" do 
    user = Fabricate(:user, password: "old_password")
    visit login_path
    click_link "Forgot Password?"
    fill_in "Email", with: user.email
    click_button "Send Email"
    
    open_email(user.email)
    current_email.click_link("Reset my password")
    
    fill_in "New Password", with: "new_password"
    click_button "Reset Password"
    
    fill_in "Email", with: user.email
    fill_in "Password", with: "new_password"
    click_button "Sign in"
    
    expect(page).to have_content(user.username)
  end
end
