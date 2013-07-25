class PaymentsController < BaseController
  include ActiveMerchant::Billing
  before_action :authenticate_user!

  def subscription_checkout
    setup_response = gateway.setup_purchase 2000,
      ip:                 request.remote_ip,
      return_url:         url_for(action: 'subscription_confirm', only_path: false),
      cancel_return_url:  url_for(action: 'mypayments', only_path: false)
    
    redirect_to gateway.redirect_url_for(setup_response.token)
  end

  def subscription_confirm
    #token=EC-680659030C156364M&PayerID=KNNAZL6NLEN6W
    @payement = Payment.new
    @payment.date = Time.now.to_datetime
    @payment.amount = 20
    @payment.mode = 'paypal'


    raise 'Hello'
    # @payment.transfer_reference = x

    @payment.save()

  end

  def subscription
		@payement = Payment.new  
	end

  def mypayments
    @payments = Payments.where(user: current_user)
  end

  private

  def gateway
    @gateway ||= PaypalExpressGateway.new(
      login:  ENV['PAYPAL_LOGIN'],
      password:  ENV['PAYPAL_PASSWORD'],
      signature:  ENV['PAYPAL_SIGNATURE']
    )
  end

  def subscription_confirm
    redirect_to action: 'index' unless params[:token]

    details_response = gateway.details_for(params[:token])

    if !details_response.success?
      @message = details_response.message
      render action: 'error'
      return 
    end
    @address = details_response.address
  end
end
