require 'spec_helper'

describe SessionsController do 

  describe "POST create" do 
    context "with valid input" do 
      before do 
        Fabricate(:user, email: "test@email.com", password: "password")
        post :create, email: "test@email.com", password: "password"
      end
      
      it "should redirect to home page" do 
        expect(response).to redirect_to home_path
      end
      
      it "should show a message in the flash" do 
        expect(flash).to be_present
      end
      
      it "should log the user in" do 
        expect(session[:user_id]).to be_present
      end
    end
    
    context "with invalid input" do 
      before do 
        post :create, email: "test@email.com", password: "wrongpassword"
      end

      it "should render the new template" do 
        expect(response).to render_template(:new)
      end
      
      it "should show a message in the flash" do 
        expect(flash).to be_present
      end
    end
  end
  
  describe "DELETE destroy" do 
    before do 
      session[:user_id] = 1
      delete :destroy
    end
    
    it "should log the user out" do 
      expect(session[:user_id]).not_to be_present
    end
    
    it "should show a message to the user" do 
      expect(flash).to be_present
    end
    
    it "should redirect to root path" do 
      expect(response).to redirect_to root_path
    end
    
  end
  
  
  
end