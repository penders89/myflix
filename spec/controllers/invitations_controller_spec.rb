require "spec_helper"

describe InvitationsController do 
  before { set_current_user }
    
  describe "GET new" do 
    it_behaves_like "require_sign_in" do 
      let(:action) { get :new } 
    end
    
    it "assigns new invitation variable" do 
      get :new
      expect(assigns(:invitation)).to be_an_instance_of(Invitation)
    end
  end
  
  describe "POST create" do 
    it_behaves_like "require_sign_in" do 
      let(:action) { post :create }
    end
    
    context "with valid input" do 
      before do 
        ActionMailer::Base.deliveries.clear
        post :create, invitation: { friend_name: "Brian", 
          friend_email: "test@email.com", message: "Some message" }
      end
        
      it "creates new invitation" do 
        expect(Invitation.count).to eq(1)
      end
      
      it "creates invitation with inviter id set to current user" do 
        expect(Invitation.first.inviter).to eq(current_user)
      end
  
      it "sends email" do 
        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end
      
      it "sends email to email address specified in form" do 
        expect(ActionMailer::Base.deliveries.last.to).to eq(["test@email.com"])
      end

      it "redirects to invitation page" do 
        expect(response).to redirect_to new_invitation_path
      end
      
      it "sets flash" do 
        expect(flash[:success]).to be_present 
      end
    end
    
    context "with invalid input" do 
      before do 
        ActionMailer::Base.deliveries.clear
        post :create, invitation: { friend_name: "Brian", 
          friend_email: "test@email.com"}
      end
      
      it "does not create new invitation" do 
        expect(Invitation.count).to eq(0)
      end
      
      it "does not send email" do 
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
      
      it "renders the new template" do 
        expect(response).to render_template :new
      end
      
      it "provides message to user" do 
        expect(flash.now).to be_present 
      end
    end
  end
end