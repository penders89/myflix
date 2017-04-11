module StripeWrapper
  class Charge
    attr_reader :error_message, :response

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options = {})
      begin
        response = Stripe::Charge.create(
          amount: options[:amount],
          card: options[:card],
          currency: "usd",
          description: options[:description],
          source: options[:source]
          )
        new(response: response)
      rescue => e
        new(error_message: e.message)
      end
    end

    def successful?
      response.present?
    end

  end
end
