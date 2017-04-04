require 'spec_helper'

describe ForgotPasswordsController do 
  describe "POST create" do
    context "with blank input" do 
      before do 
        post :create, email: ""
      end
      
      it "redirects to forgot password page" do 
        expect(response).to redirect_to forgot_password_path 
      end
      
      it "shows error message" do 
        expect(flash[:danger]).to be_present 
      end
    end
    
    context "with existing email" do 
      let(:user) { Fabricate(:user) } 
      
      before do 
        post :create, email: user.email 
      end
      
      it "should redirect toforgot password confirmation page" do 
        expect(response).to redirect_to forgot_password_confirmation_path
      end  
      
      it "sends out email to email address" do 
        expect(ActionMailer::Base.deliveries.last.to).to eq([user.email]) 
      end
    end
      
    context "with non-existent email" do 
      before do 
        post :create, email: "email"
      end
        
      it "redirects to forgot password page" do 
        expect(response).to redirect_to forgot_password_path
      end
      
      it "should show error message" do 
        expect(flash[:danger]).to be_present 
      end
      
    end
  end
end