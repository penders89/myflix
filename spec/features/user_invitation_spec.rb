require 'spec_helper'

feature "User invitations" do 
  scenario "user sends invitation and another user responds", js: true do 
    clear_emails
    user = Fabricate(:user)
    sign_in(user)
    visit new_invitation_path
    fill_in "Friend's Name", with: "Test Name"
    fill_in "Friend's Email Address", with: "test@example.com"
    click_button "Send Invitation"
    sign_out
    
    
    open_email("test@example.com")
    current_email.click_link "Sign up for an account"
    sleep 5
    expect(page).to have_selector "input[value='test@example.com']"
    
    fill_in "Username", with: "Test username"
    fill_in "Password", with: "Password"
    within_frame("__privateStripeFrame2") do
      find("input[name='cardnumber']").set("4242424242424242")
      find("input[name='exp-date']").set("17/19")
      find("input[name='cvc']").set("123")
    end
    click_button "Register"
    
    visit login_path 
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "Password"
    click_button "Sign in"
    
    click_link "People" 
    expect(page).to have_content user.username
    sign_out 
    
    sign_in(user)
    click_link "People"
    expect(page).to have_content "Test username"
  end
end
