require 'spec_helper'

describe UsersController do 
  describe "GET new" do 
    before do 
      get :new
    end
    
    it "should assign the @user variable" do 
      expect(assigns(:user)).to be_an_instance_of(User)
    end
  end
  
  describe "POST create" do 
    context "with valid input" do 
      before do 
        post :create, user: { username: "Name", password: "password", 
          email: "test@email.com" }
      end  
      
      it "should create the user" do 
        expect(User.count).to eq(1)
      end
      
      it "should redirect to login page" do 
        expect(response).to redirect_to login_path
      end
      
      it "should show a message in the flash" do 
        expect(flash).to be_present
      end
    end
    
    context "with invalid input" do 
      before do 
        post :create, user: { username: "Name", password: "invalid", 
          email: "test@email.com" }
      end
      
      it "should render the new template" do 
        expect(response).to render_template(:new)
      end
      
      it "should assign the @user variable" do 
        expect(assigns(:user)).to be_instance_of(User)
      end
      
      it "should not create a user" do 
        expect(User.count).to eq(0)
      end
    end
  end
end