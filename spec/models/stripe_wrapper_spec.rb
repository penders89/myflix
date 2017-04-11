require "spec_helper"

describe StripeWrapper do
  let(:valid_token) do
    Stripe::Token.create(
      :card => {
        :number => "4242424242424242",
        :exp_month => 4,
        :exp_year => 2018,
        :cvc => "314"
      },
    ).id
  end

  let(:decline_card_token) do
    Stripe::Token.create(
      :card => {
        :number => "4000000000000002",
        :exp_month => 4,
        :exp_year => 2018,
        :cvc => "314"
      },
    ).id
  end

  describe ".create" do
    it "makes a successful charge", :vcr do
      response = StripeWrapper::Charge.create({
        amount: 999,
        source: valid_token,
        description: "a valid charge"
      })

      expect(response).to be_successful
    end

    it "makes a card declined charge", :vcr do
      response = StripeWrapper::Charge.create({
        amount: 999,
        source: decline_card_token,
        description: "an invalid charge"
      })

      expect(response).not_to be_successful
    end

    it "returns the error message for declined charges", :vcr do
      response = StripeWrapper::Charge.create({
        amount: 999,
        source: decline_card_token,
        description: "an invalid charge"
      })

      expect(response.error_message).to eq("Your card was declined.")
    end
  end

  describe StripeWrapper::Customer do
    describe ".create" do
      it "creates a customer with a valid card", :vcr do
        user = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: user,
          source: valid_token
        )
        expect(response).to be_successful
      end

      it "does not create a customer with an invalid card", :vcr do
          user = Fabricate(:user)
          response = StripeWrapper::Customer.create(
            user: user,
            source: decline_card_token
          )
          expect(response).not_to be_successful
      end

      it "returns the error message for declined card", :vcr do
        user = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: user,
          source: decline_card_token
        )
        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end
end
