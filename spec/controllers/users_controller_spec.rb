require 'spec_helper'

describe UsersController do 
  describe "GET new" do 

    it "should assign the @user variable" do 
      get :new
      expect(assigns(:user)).to be_an_instance_of(User)
    end
    
    it "should set the email for the user variable if responding to an invite" do
      invitation = Fabricate(:invitation)
      get :new, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.friend_email)
    end
  end
  
  describe "GET show" do 
    it_behaves_like "require_sign_in" do 
      let(:action) { get :show, id: 1 }
    end
    
    it "sets user variable" do 
      set_current_user
      user = Fabricate(:user)
      get :show, id: user.id
      expect(assigns(:user)).to eq(user)
    end
  end
  
  describe "POST create" do 
    before do 
      StripeWrapper::Charge.stub(:create)
    end 
    
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
      
      it "sends out email to user" do 
        expect(ActionMailer::Base.deliveries.last.to).to eq(["test@email.com"])
      end
      
      it "sends out email containing user's name" do 
        expect(ActionMailer::Base.deliveries.last.body).to include("Name")
      end
    end
    
    context "with valid input following invite" do 
      let(:user) { Fabricate(:user) }
      
      before do 
        invitation = Fabricate(:invitation, friend_email: "test@email.com", 
        inviter: user)
        post :create, user: { username: "Name", password: "password", 
          email: "test@email.com"}, token: invitation.token 
      end
      
      it "should set new user to follow inviter" do 
        expect(user.following_relationships.first.leader).to eq(User.last)
      end
      
      it "should set inviter to follow new user" do 
        expect(User.last.following_relationships.first.leader).to eq(user)
      end
      
    end
    
    
    context "with invalid input" do 
      before do 
        ActionMailer::Base.deliveries.clear 
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
      
      it "does not send out email" do 
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      
    end
  end
end