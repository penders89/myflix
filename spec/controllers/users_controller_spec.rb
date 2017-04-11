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
    context "with successful user signup" do
      let(:result) { double(:result, successful?: true)}

      before do
        expect_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
        post :create, user: { username: "Name", password: "password",
          email: "test@email.com"}, stripeToken: "12345"
      end

      it "should redirect to login page", :vcr do
        expect(response).to redirect_to login_path
      end

      it "should show a message in the flash", :vcr do
        expect(flash).to be_present
      end
    end

    context "with unsuccessful signup" do
      let(:result) { double(:result, successful?: false, error_message: "Some message")}

      before do
        expect_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
        post :create, user: { username: "Name", password: "password",
          email: "test@email.com"}, stripeToken: "12345"
      end

      it "should assign user variable" do
        expect(assigns(:user)).to be_an_instance_of(User)
      end

      it "renders the new template", :vcr do
        expect(response).to render_template :new
      end

      it "sets the flash error message", :vcr do
        expect(flash[:danger]).to be_present
      end
    end

  end
end
