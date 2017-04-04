require 'spec_helper'

feature 'User following' do 
  scenario "user follows and unfollows someone" do 
    user = Fabricate(:user)
    category = Fabricate(:category)
    video = Fabricate(:video, category: category)
    Fabricate(:review, video: video, user: user)
    
    sign_in
    click_on_video_on_home_page(video)
    
    click_link user.username
    click_link "Follow"
    expect(page).to have_content user.username
    
    unfollow(user)
    expect(page).not_to have_content user.username
    
    
  end
  
  def unfollow(user)
    find("a[href^='/relationships']").click
  end
  
end
