def set_current_user
  user = Fabricate(:user)
  session[:user_id] = user.id
end

def set_current_admin
  session[:user_id] = Fabricate(:admin).id
end


def current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end

def sign_in(a_user=nil)
  user = a_user || Fabricate(:user)
  visit login_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def click_on_video_on_home_page(video)
  find("a[href='/videos/#{video.id}']").click
end

def sign_out
  visit home_path
  find('a', text: /Welcome/).click
  click_link "Sign Out"
end
