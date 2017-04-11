require "spec_helper"

describe UserSignup do
  describe "#sign_up" do
    context "valid personal info and valid card" do
      let(:charge) { double(:charge, successful?: true)}
      let(:user) { Fabricate(:user, email: "test@example.com", username: "Test") }

      before do
        expect(StripeWrapper::Customer).to receive(:create).and_return(charge)
        UserSignup.new(user).sign_up("token", nil)
      end

      after do
        ActionMailer::Base.deliveries.clear
      end

      it "creates a user" do
        expect(User.count).to eq(1)
      end

      it "sends out email to user" do
        expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
      end

      it "sends out email contaning users name" do
        expect(ActionMailer::Base.deliveries.last.body).to include(user.username)
      end
    end

    context "with valid input and declined card" do
      let(:charge) { double(:charge, successful?: false, error_message: "Error message")}
      let(:user) { User.new(Fabricate.attributes_for(:user, email: "test@example.com", username: "Test")) }

      before do
        expect(StripeWrapper::Customer).to receive(:create).and_return(charge)
        UserSignup.new(user).sign_up("token", nil)
      end

      after do
        ActionMailer::Base.deliveries.clear
      end

      it "does not create a new user" do
        expect(User.count).to eq(0)
      end
    end

    context "with valid input following invite" do
      let(:charge) { double(:charge, successful?: true)}
      let(:user) { Fabricate(:user) }
      let(:invitation) {Fabricate(:invitation, friend_email: "test@example.com", inviter: user) }

      before do
        expect(StripeWrapper::Customer).to receive(:create).and_return(charge)
        new_user = User.new(Fabricate.attributes_for(:user, email: "test@example.com"))
        UserSignup.new(new_user).sign_up("token", invitation.token)
      end

      it "sets new user to follow inviter" do
        expect(user.following_relationships.first.leader).to eq(User.last)
      end

      it "sets inviter to follow new user" do
        expect(User.last.following_relationships.first.leader).to eq(user)
      end
    end

    context "with invalid input" do
      let(:charge) { double(:charge, successful?: true)}
      let(:user) { User.new(Fabricate.attributes_for(:user)) }

      before do
        ActionMailer::Base.deliveries.clear
        user.email = ""
        UserSignup.new(user).sign_up("token", nil)
      end

      it "should not create a user" do
        expect(User.count).to eq(0)
      end

      it "should not send email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end
