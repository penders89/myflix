require 'spec_helper'

feature 'user interacts with queue' do 
  scenario 'user adds and reorders videos in the queue' do 
    category = Fabricate(:category)
    video1 = Fabricate(:video, category: category)
    video2 = Fabricate(:video, category: category)
    video3 = Fabricate(:video, category: category)
    
    sign_in 
    
    add_video_to_queue(video1)
    expect_video_to_be_in_queue(video1)
    
    visit video_path(video1)
    expect_link_not_to_be_seen("+ My Queue")
    
    add_video_to_queue(video2)
    add_video_to_queue(video3)
    
    set_video_position(video1, 3)
    set_video_position(video2, 1)
    set_video_position(video3, 2)
    update_queue
    
    expect_video_position(video1, 3)
    expect_video_position(video2, 1)
    expect_video_position(video3, 2)
  end
  
  def expect_video_to_be_in_queue(video)
    expect(page).to have_content video.title
  end
  
  def expect_link_not_to_be_seen(link)
    expect(page).not_to have_content link
  end

  def add_video_to_queue(video) 
    visit home_path
    click_on_video_on_home_page(video)
    click_link "+ My Queue"
  end

  def set_video_position(video, position)
    find("input[data-video-id='#{video.id}']").set(position)
  end
  
  def update_queue
    click_on "Update Instant Queue" 
  end
  
  def expect_video_position(video, position)
    expect(find("input[data-video-id='#{video.id}']").value).to eq(position.to_s)
  end
end