require 'spec_helper'

feature 'Admin adds new video' do 
  scenario 'Admin successfully adds a new video' do 
    admin = Fabricate(:admin)
    category = Fabricate(:category)
    sign_in admin
    visit new_admin_video_path 
    
    fill_in "Title", with: "Monk"
    select category.name, from: "Category"
    fill_in "Description", with: "Description"
    attach_file "Large cover", "spec/support/uploads/monk_large.jpg"
    attach_file "Small cover", "spec/support/uploads/monk.jpg"
    fill_in "Video url", with: "https://someurl.com"

    click_button "Add Video"
    
    sign_out
    sign_in
    
    visit video_path(Video.first)
    expect(page).to have_selector("img[src='/uploads/monk_large.jpg']")

    expect(page).to have_selector("a[href='https://someurl.com']")
  end
end