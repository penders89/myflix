require 'spec_helper'

describe PasswordResetsController do
  describe "GET show" do 
    let(:user) { Fabricate(:user) }
    
    it "renders show template if token is valid" do
      get :show, id: user.token
      expect(response).to render_template :show
    end
    
    it "sets token if token is valid" do 
      get :show, id: user.token
      expect(assigns(:token)).to eq(user.token)
    end
    
    it "redirects to expired token page if token is not valid" do 
      get :show, id: '123'
      expect(response).to redirect_to expired_token_path
    end
    
    
  end
  
  describe "POST create" do 
    context "with valid token" do 
      let(:user) { Fabricate(:user) }
      
      before do 
        user.update_column(:token, '12345')
        post :create, token: user.token, password: "password"
      end
      
      it "should update users password" do 
        expect(user.reload.authenticate("password")).to be_truthy
      end
        
      it "redirects to sign in page" do 
        expect(response).to redirect_to login_path 
      end
      
      it "sets flash success message" do 
        expect(flash[:success]).to be_present 
      end
      
      it "regenerates the users token" do 
        expect(user.reload.token).not_to eq('12345')
      end
    end
    
    context "with invalid token" do 
      it "should redirect to expired path" do 
        post :create, token: '12345', password: "password"
        expect(response).to redirect_to expired_token_path
      end
    end
  end
  
end
  